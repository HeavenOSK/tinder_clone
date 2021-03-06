import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tinder_clone/pages/home/swipable_positioned.dart';
import 'package:tinder_clone/pages/home/swipe_session_state/swipe_sesion_state.dart';

extension _Animating on AnimationController {
  bool get animating =>
      status == AnimationStatus.forward || status == AnimationStatus.reverse;
}

enum SwipeDirection {
  left,
  right,
}

typedef SwipeCompletionCallback = void Function(
  int index,
  SwipeDirection direction,
);

typedef OnWillMoveNext = bool Function(
  int index,
  SwipeDirection direction,
);

// TODO(heavenOSK): Controller ロジック
// TODO(heavenOSK): カードにラベルを表示する　API
class SwipableStack extends StatefulWidget {
  const SwipableStack({
    @required this.builder,
    this.onSwipeCompleted,
    this.onWillMoveNext,
    this.itemCount,
    Key key,
  }) : super(key: key);

  final IndexedWidgetBuilder builder;
  final SwipeCompletionCallback onSwipeCompleted;
  final OnWillMoveNext onWillMoveNext;
  final int itemCount;

  @override
  SwipableStackState createState() => SwipableStackState();
}

class SwipableStackState extends State<SwipableStack>
    with TickerProviderStateMixin {
  AnimationController _swipeCancelAnimationController;
  AnimationController _swipeAssistAnimationController;
  Animation<Offset> _positionAnimation;

  bool get animating =>
      _swipeCancelAnimationController.animating ||
      _swipeAssistAnimationController.animating;

  bool get canSwipeStart =>
      !animating ||
      (_swipeCancelAnimationController.animating &&
          _swipeCancelAnimationController.value < 0.1);

  int _currentIndex = 0;
  static const double _defaultSwipeThreshold = 0.22;

  var _sessionState = const SwipeSessionState();

  SwipeSessionState get sessionState => _sessionState;

  set sessionState(SwipeSessionState newState) {
    assert(newState != null, 'sessionState cannot be updated with $newState');
    if (newState == null) {
      return;
    }
    if (_sessionState != newState) {
      _sessionState = newState;
    }
  }

  bool get _allowMoveNext {
    final isDirectionRight = sessionState.diff.dx > 0;
    final swipeDirection =
        isDirectionRight ? SwipeDirection.right : SwipeDirection.left;
    return widget.onWillMoveNext?.call(
          _currentIndex,
          swipeDirection,
        ) ??
        true;
  }

  @override
  void initState() {
    super.initState();
    _swipeCancelAnimationController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _swipeAssistAnimationController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: _buildCards(context, constraints),
        );
      },
    );
  }

  List<Widget> _buildCards(BuildContext context, BoxConstraints constraints) {
    final cards = <Widget>[];
    for (var index = _currentIndex;
        index < min(_currentIndex + 3, widget.itemCount ?? _currentIndex + 3);
        index++) {
      cards.add(
        widget.builder(
          context,
          index,
        ),
      );
    }
    return List.generate(
      cards.length,
      (index) {
        return SwipablePositioned(
          state: _sessionState,
          index: index,
          areaConstraints: constraints,
          onPanStart: (d) {
            if (!canSwipeStart) {
              return;
            }

            if (_swipeCancelAnimationController.animating) {
              _swipeCancelAnimationController
                ..stop()
                ..reset();
            }
            setState(() {
              sessionState = sessionState.copyWith(
                localPosition: d.localPosition,
                startPosition: d.globalPosition,
                currentPosition: d.globalPosition,
              );
            });
          },
          onPanUpdate: (d) {
            if (!canSwipeStart) {
              return;
            }
            if (_swipeCancelAnimationController.animating) {
              _swipeCancelAnimationController
                ..stop()
                ..reset();
            }
            setState(() {
              sessionState = sessionState.copyWith(
                localPosition: sessionState.localPosition ?? d.localPosition,
                startPosition: sessionState.startPosition ?? d.globalPosition,
                currentPosition: d.globalPosition,
              );
            });
          },
          onPanEnd: (d) {
            if (animating) {
              return;
            }
            final shouldMoveBack = (_sessionState.diff?.dx?.abs() ?? 0) <=
                constraints.maxWidth * _defaultSwipeThreshold;
            if (shouldMoveBack) {
              _cancelSwipe();
              return;
            }
            if (_allowMoveNext) {
              _moveNext();
            } else {
              _cancelSwipe();
            }
          },
          child: cards[index],
        );
      },
    ).reversed.toList();
  }

  void _animatePosition() {
    if (_positionAnimation != null) {
      setState(() {
        sessionState = sessionState.copyWith(
          currentPosition: _positionAnimation.value,
        );
      });
    }
  }

  void _cancelSwipe() {
    _positionAnimation = Tween<Offset>(
      begin: sessionState.currentPosition,
      end: sessionState.startPosition,
    ).animate(
      CurvedAnimation(
        parent: _swipeCancelAnimationController,
        curve: const ElasticOutCurve(0.95),
      ),
    )..addListener(_animatePosition);

    /// It's done.
    _swipeCancelAnimationController.forward(from: 0).then(
      (_) {
        _positionAnimation.removeListener(_animatePosition);
        setState(() {
          sessionState = const SwipeSessionState();
        });
      },
    );
  }

  void _moveNext() {
    final isDirectionRight = sessionState.diff.dx > 0;
    final swipeDirection =
        isDirectionRight ? SwipeDirection.right : SwipeDirection.left;

    final deviceWidth = MediaQuery.of(context).size.width;
    final diffXAbs = sessionState.diff.dx.abs();
    final multiple =
        (deviceWidth - diffXAbs * 0.25) / sessionState.diff.dx.abs();
    _positionAnimation = Tween<Offset>(
      begin: sessionState.currentPosition,
      end: sessionState.currentPosition + sessionState.diff * multiple,
    ).animate(
      CurvedAnimation(
        parent: _swipeAssistAnimationController,
        curve: Curves.easeOutCubic,
      ),
    )..addListener(_animatePosition);

    /// It's done.
    _swipeAssistAnimationController.forward(from: 0).then(
      (_) {
        widget.onSwipeCompleted?.call(
          _currentIndex,
          swipeDirection,
        );
        _positionAnimation.removeListener(_animatePosition);
        setState(() {
          _currentIndex += 1;
          sessionState = const SwipeSessionState();
        });
      },
    );
  }

  @override
  void dispose() {
    _swipeCancelAnimationController?.dispose();
    _swipeAssistAnimationController?.dispose();
    super.dispose();
  }
}
