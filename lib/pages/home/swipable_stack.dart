import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tinder_clone/pages/home/card_builder.dart';
import 'package:tinder_clone/pages/home/controller/swipe_session_state.dart';

extension _Animating on AnimationController {
  bool get animating =>
      status == AnimationStatus.forward || status == AnimationStatus.reverse;
}

typedef CardBuilder = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
);

class SwipableStack extends StatefulWidget {
  const SwipableStack({
    @required this.cardBuilder,
    Key key,
  }) : super(key: key);

  final CardBuilder cardBuilder;

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

  @override
  void initState() {
    super.initState();
    _moveBackAnimationController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _swipeAssistAnimationController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
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

    final deviceWidth = MediaQuery.of(context).size.width;
    final multiple = deviceWidth / _sessionState.diff.dx.abs();
    _positionAnimation = Tween<Offset>(
      begin: sessionState.currentPosition,
      end: sessionState.currentPosition + sessionState.diff * multiple * 1.5,
    ).animate(
      CurvedAnimation(
        parent: _swipeAssistAnimationController,
        curve: Curves.easeOutCubic,
      ),
    )..addListener(_updatePosition);

    /// It's done.
    _swipeAssistAnimationController.forward(from: 0).then(
      (_) {
        _positionAnimation.removeListener(_updatePosition);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final diff = sessionState.diff ?? Offset.zero;
    return LayoutBuilder(
      builder: (context, constraints) {
        final x = diff.dx.abs();
        final p = x != null ? x / (MediaQuery.of(context).size.width * 0.4) : 0;
        final percentage = min(p, 1);
        final diffConstraints = constraints * (0.1 * (1 - percentage));

        return Stack(
          children: [
            Positioned(
              top: Offset.zero.dy + diffConstraints.maxHeight / 2,
              left: Offset.zero.dx + diffConstraints.maxWidth / 2,
              child: CardBuilderWidget(
                canSwipe: false,
                constraints: constraints * (0.9 + 0.1 * percentage),
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
                state: _sessionState,
                builder: widget.cardBuilder,
              ),
            ),
            Positioned(
              top: diff.dy,
              left: diff.dx,
              child: Opacity(
                opacity: 0.7,
                child: CardBuilderWidget(
                  canSwipe: true,
                  constraints: constraints,
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
                  state: _sessionState,
                  builder: widget.cardBuilder,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _moveBackAnimationController?.dispose();
    _swipeAssistAnimationController?.dispose();
    super.dispose();
  }
}
