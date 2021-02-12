import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tinder_clone/pages/home/controller/swipe_session_state.dart';
import 'package:tinder_clone/pages/home/swipable_stack.dart';

class CardBuilderWidget extends StatelessWidget {
  const CardBuilderWidget({
    @required this.state,
    @required this.constraints,
    @required this.onPanStart,
    @required this.onPanUpdate,
    @required this.onPanEnd,
    @required this.builder,
    @required this.canSwipe,
    Key key,
  }) : super(key: key);

  final SwipeSessionState state;
  final CardBuilder builder;
  final BoxConstraints constraints;
  final GestureDragStartCallback onPanStart;
  final GestureDragUpdateCallback onPanUpdate;
  final GestureDragEndCallback onPanEnd;
  final bool canSwipe;

  @override
  Widget build(BuildContext context) {
    final diff = state.diff ?? Offset.zero;
    return Transform.rotate(
      angle:
          canSwipe ? -(diff.dx ?? 0) / constraints.maxWidth * math.pi / 24 : 0,
      origin: canSwipe ? state.localPosition ?? Offset.zero : Offset.zero,
      child: ConstrainedBox(
        constraints: constraints,
        child: IgnorePointer(
          ignoring: !canSwipe,
          child: GestureDetector(
            onPanStart: onPanStart,
            onPanUpdate: onPanUpdate,
            onPanEnd: onPanEnd,
            child: builder(
              context,
              constraints,
            ),
          ),
        ),
      ),
    );
  }
}
