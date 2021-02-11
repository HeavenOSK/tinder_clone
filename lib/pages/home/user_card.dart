import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tinder_clone/pages/home/controller/swipe_session_state.dart';
import 'package:tinder_clone/pages/home/frame.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    @required this.state,
    @required this.onPanStart,
    @required this.onPanUpdate,
    @required this.onPanEnd,
    Key key,
  }) : super(key: key);

  final SwipeSessionState state;
  final GestureDragStartCallback onPanStart;
  final GestureDragUpdateCallback onPanUpdate;
  final GestureDragEndCallback onPanEnd;

  static const padding = EdgeInsets.all(8);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceHeight = size.height;
    final deviceWidth = size.width;

    final diff = state.diff ?? Offset.zero;
    return Transform.rotate(
      angle: -(diff.dx ?? 0) / deviceWidth * math.pi / 24,
      origin: state.localFingerPosition ?? Offset.zero,
      child: GestureDetector(
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        child: Container(
          height: deviceHeight -
              Frame.topPadding(context) -
              Frame.bottomPadding -
              padding.top * 2,
          width: deviceWidth - padding.left * 2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 15,
                spreadRadius: 0,
                color: Colors.black.withOpacity(0.25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
