import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'swipe_session_state.freezed.dart';

enum SwipeSessionPhase {
  waiting,
  hold,
  finish,
}

extension SwipeSessionStateX on SwipeSessionState {
  SwipeSessionPhase get phase {
    if (startPosition == null && currentPosition == null) {
      return SwipeSessionPhase.waiting;
    } else if (currentPosition == null) {
      return SwipeSessionPhase.finish;
    } else {
      return SwipeSessionPhase.hold;
    }
  }

  Offset get diff {
    if (this == null || currentPosition == null || startPosition == null) {
      return null;
    }
    return currentPosition - startPosition;
  }

  Offset get localFingerPosition {
    if (localPosition == null) {
      return null;
    }
    return localPosition + Offset(0, -50);
  }
}

@freezed
abstract class SwipeSessionState with _$SwipeSessionState {
  const factory SwipeSessionState({
    @nullable Offset startPosition,
    @nullable Offset currentPosition,
    @nullable Offset localPosition,
  }) = _SwipeSessionState;
}
