import 'package:flutter/material.dart';
import 'package:tinder_clone/pages/home/swipable_stack.dart';

class SwipableStackController extends ChangeNotifier {
  SwipableStackController();

  final swipableStackStateKey = GlobalKey<SwipableStackState>();

  void moveNext(SwipeDirection direction) {
    swipableStackStateKey.currentState?.moveNext(direction);
  }
}