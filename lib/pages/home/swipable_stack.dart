import 'package:flutter/material.dart';
import 'package:tinder_clone/pages/home/controller/swipe_session_state.dart';
import 'package:tinder_clone/pages/home/swaipable_positioned.dart';

extension _Animating on AnimationController {
  bool get animating =>
      status == AnimationStatus.forward || status == AnimationStatus.reverse;
}

typedef CardBuilder = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
  int index,
);

enum SwipeDirection {
  left,
  right,
}

typedef SwipCompletionCallback = void Function(
  int index,
  SwipeDirection direction,
);

class SwipableStack extends StatefulWidget {
  SwipableStack({
    @required this.cardBuilder,
    @required this.itemCount,
    @required this.onSwipeCompleted,
    Key key,
  }) : super(key: key);

  final CardBuilder cardBuilder;
  final int itemCount;
  SwipCompletionCallback onSwipeCompleted;

  static double swipeThreshold(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.22;

  @override
  _SwipableStackState createState() => _SwipableStackState();
}

class _SwipableStackState extends State<SwipableStack>
    with TickerProviderStateMixin {
  AnimationController _moveBackAnimationController;
  AnimationController _swipeAssistAnimationController;
  Animation<Offset> _positionAnimation;

  bool get animating =>
      _moveBackAnimationController.animating &&
      _swipeAssistAnimationController.animating;

  bool get canSwipe =>
      !animating ||
      (_moveBackAnimationController.animating && sessionState.diff.dx < 10);

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _moveBackAnimationController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _swipeAssistAnimationController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  var _sessionState = const SwipeSessionState();

  SwipeSessionState get sessionState => _sessionState;

  set sessionState(SwipeSessionState newState) {
    if (_sessionState != newState) {
      setState(() {
        _sessionState = newState;
      });
    }
  }

  void startToHold({
    @required Offset offset,
    @required Offset localPosition,
  }) {
    if (!canSwipe) {
      return;
    }

    if (_moveBackAnimationController.animating) {
      _moveBackAnimationController.stop();
    }
    sessionState = sessionState.copyWith(
      localPosition: localPosition,
      startPosition: offset,
      currentPosition: offset,
    );
  }

  void updatePosition({
    @required Offset offset,
    @required Offset localPosition,
  }) {
    if (!canSwipe) {
      return;
    }
    if (_moveBackAnimationController.animating) {
      _moveBackAnimationController.stop();
    }
    sessionState = sessionState.copyWith(
      localPosition: sessionState.localPosition ?? localPosition,
      startPosition: sessionState.startPosition ?? offset,
      currentPosition: offset,
    );
  }

  void leave() {
    if (animating) {
      return;
    }

    final shouldMoveBack =
        _sessionState.diff.dx.abs() <= SwipableStack.swipeThreshold(context);
    if (shouldMoveBack) {
      _moveBack();
    } else {
      _moveNext();
    }
  }

  void _moveBack() {
    void _updatePosition() {
      if (_positionAnimation != null) {
        sessionState = sessionState.copyWith(
          currentPosition: _positionAnimation.value,
        );
      }
    }

    _positionAnimation = Tween<Offset>(
      begin: sessionState.currentPosition,
      end: sessionState.startPosition,
    ).animate(
      CurvedAnimation(
        parent: _moveBackAnimationController,
        curve: const ElasticOutCurve(0.95),
      ),
    )..addListener(_updatePosition);

    /// It's done.
    _moveBackAnimationController.forward(from: 0).then(
      (_) {
        _positionAnimation.removeListener(_updatePosition);
        sessionState = const SwipeSessionState();
      },
    );
  }

  void _moveNext() {
    void _updatePosition() {
      if (_positionAnimation != null) {
        sessionState = sessionState.copyWith(
          currentPosition: _positionAnimation.value,
        );
      }
    }

    final isDirectionRight = sessionState.diff.dx > 0;
    void _complete() {
      widget.onSwipeCompleted(
        _currentIndex,
        isDirectionRight ? SwipeDirection.right : SwipeDirection.left,
      );
    }

    final deviceWidth = MediaQuery.of(context).size.width;
    final diffXAbs = _sessionState.diff.dx.abs();
    final multiple =
        (deviceWidth - diffXAbs * 0.25) / _sessionState.diff.dx.abs();
    _positionAnimation = Tween<Offset>(
      begin: sessionState.currentPosition,
      end: sessionState.currentPosition + sessionState.diff * multiple * 1,
    ).animate(
      CurvedAnimation(
        parent: _swipeAssistAnimationController,
        curve: Curves.easeOutCubic,
      ),
    )..addListener(_updatePosition);

    /// It's done.
    _swipeAssistAnimationController.forward(from: 0).then(
      (_) {
        _complete?.call();
        _positionAnimation.removeListener(_updatePosition);
        setState(() {
          _currentIndex += 1;
          sessionState = const SwipeSessionState();
        });
      },
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
    for (var index = _currentIndex; index < _currentIndex + 3; index++) {
      cards.add(
        widget.cardBuilder(
          context,
          constraints,
          index,
        ),
      );
    }
    return List.generate(cards.length, (index) {
      return SwipablePositioned(
        state: _sessionState,
        index: index,
        areaConstraints: constraints,
        onPanStart: (d) {
          startToHold(
            offset: d.globalPosition,
            localPosition: d.localPosition,
          );
        },
        onPanUpdate: (d) {
          updatePosition(
            offset: d.globalPosition,
            localPosition: d.localPosition,
          );
        },
        onPanEnd: (d) {
          leave();
        },
        child: cards[index],
      );
    }).reversed.toList();
  }

  @override
  void dispose() {
    _moveBackAnimationController?.dispose();
    _swipeAssistAnimationController?.dispose();
    super.dispose();
  }
}
