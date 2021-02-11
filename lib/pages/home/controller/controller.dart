import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tinder_clone/pages/home/controller/swipe_session_state.dart';

export 'package:tinder_clone/pages/home/controller/swipe_session_state.dart';

class SwipeSessionController extends StateNotifier<SwipeSessionState> {
  SwipeSessionController() : super(const SwipeSessionState());

  void startToHold(
    Offset offset,
    Offset localPosition,
  ) {
    state = state.copyWith(
      startPosition: offset,
      currentPosition: offset,
      localPosition: localPosition,
    );
  }

  void updatePosition(Offset offset) {
    state = state.copyWith(
      currentPosition: offset,
    );
  }

  void leave() {
    state = state.copyWith(
      currentPosition: null,
    );
  }
}
