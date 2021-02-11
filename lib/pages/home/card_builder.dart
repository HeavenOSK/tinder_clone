import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tinder_clone/pages/home/controller/swipe_session_state.dart';
import 'package:tinder_clone/pages/home/home.dart';

class CardBuilderWidget extends StatelessWidget {
  const CardBuilderWidget({
    @required this.state,
    @required this.constraints,
    @required this.onPanStart,
    @required this.onPanUpdate,
    @required this.onPanEnd,
    @required this.builder,
    Key key,
  }) : super(key: key);

  final SwipeSessionState state;
  final CardBuilder builder;
  final BoxConstraints constraints;
  final GestureDragStartCallback onPanStart;
  final GestureDragUpdateCallback onPanUpdate;
  final GestureDragEndCallback onPanEnd;

  @override
  Widget build(BuildContext context) {
    final diff = state.diff ?? Offset.zero;
    return Transform.rotate(
      angle: -(diff.dx ?? 0) / constraints.maxWidth * math.pi / 24,
      origin: state.localPosition ?? Offset.zero,
      child: ConstrainedBox(
        constraints: constraints,
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
    );
  }
}
