import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tinder_clone/pages/home/swipe_sesion_state.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    @required this.state,
    @required this.constraints,
    @required this.onPanStart,
    @required this.onPanUpdate,
    @required this.onPanEnd,
    Key key,
  }) : super(key: key);

  final SwipeSessionState state;
  final BoxConstraints constraints;
  final GestureDragStartCallback onPanStart;
  final GestureDragUpdateCallback onPanUpdate;
  final GestureDragEndCallback onPanEnd;

  static const padding = EdgeInsets.all(8);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceWidth = size.width;

    final diff = state.differecne ?? Offset.zero;

    return Transform.rotate(
      angle: -(diff.dx ?? 0) / deviceWidth * math.pi / 24,
      origin: state.localFingerPosition ?? Offset.zero,
      child: ConstrainedBox(
        constraints: constraints,
        child: GestureDetector(
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanEnd: onPanEnd,
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
