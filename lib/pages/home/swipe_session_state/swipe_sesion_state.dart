import 'package:flutter/material.dart';

extension SwipeSessionStateX on SwipeSessionState {
  Offset get diff {
    if (this == null || currentPosition == null || startPosition == null) {
      return Offset.zero;
    }
    return currentPosition - startPosition;
  }

  Offset get localFingerPosition {
    if (localPosition == null) {
      return null;
    }
    return localPosition + const Offset(0, -50);
  }
}

class SwipeSessionState {
  const SwipeSessionState({
    this.startPosition,
    this.currentPosition,
    this.localPosition,
  });

  final Offset startPosition;
  final Offset currentPosition;
  final Offset localPosition;

  @override
  bool operator ==(Object other) =>
      other is SwipeSessionState &&
      startPosition == other.startPosition &&
      currentPosition == other.currentPosition &&
      localPosition == other.localPosition;

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      (startPosition?.hashCode ?? null.hashCode) ^
      (currentPosition?.hashCode ?? null.hashCode) ^
      (localPosition?.hashCode ?? null.hashCode);

  @override
  String toString() => '$SwipeSessionState('
      'startPosition:$startPosition,'
      'currentPosition:$currentPosition,'
      'localPosition:$localPosition'
      ')';

  SwipeSessionState copyWith({
    Offset startPosition,
    Offset currentPosition,
    Offset localPosition,
  }) =>
      SwipeSessionState(
        startPosition: startPosition ?? this.startPosition,
        currentPosition: currentPosition ?? this.currentPosition,
        localPosition: localPosition ?? this.localPosition,
      );
}
