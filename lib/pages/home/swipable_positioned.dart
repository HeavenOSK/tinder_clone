import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tinder_clone/pages/home/swipe_sesion_state.dart';

class SwipablePositioned extends StatelessWidget {
  const SwipablePositioned({
    @required this.index,
    @required this.state,
    @required this.areaConstraints,
    @required this.child,
    Key key,
  }) : super(key: key);

  static Widget overlay({
    @required SwipeSessionState sessionState,
    @required BoxConstraints areaConstraints,
    @required Widget child,
  }) {
    return SwipablePositioned(
      state: sessionState,
      index: 0,
      areaConstraints: areaConstraints,
      child: IgnorePointer(
        child: child,
      ),
    );
  }

  final int index;
  final SwipeSessionState state;
  final Widget child;
  final BoxConstraints areaConstraints;

  Offset get _currentPositionDiff => state.differecne ?? Offset.zero;

  bool get _isFirst => index == 0;

  bool get _isSecond => index == 1;

  double get _rotationAngle => _isFirst
      ? -(_currentPositionDiff.dx ?? 0) /
          areaConstraints.maxWidth *
          math.pi /
          24
      : 0;

  Offset get _rotationOrigin =>
      _isFirst ? state.localPosition ?? Offset.zero : Offset.zero;

  static const double _animationRate = 0.1;

  double _animationProgress(BuildContext context) {
    final x = _currentPositionDiff.dx.abs();
    final p = x != null ? x / (MediaQuery.of(context).size.width * 0.4) : 0;
    return min(p.toDouble(), 1);
  }

  BoxConstraints _constraints(BuildContext context) {
    if (_isFirst) {
      return areaConstraints;
    } else if (_isSecond) {
      return areaConstraints *
          (1 - _animationRate + _animationRate * _animationProgress(context));
    } else {
      return areaConstraints * (1 - _animationRate);
    }
  }

  Offset _preferredPosition(BuildContext context) {
    if (_isFirst) {
      return _currentPositionDiff;
    } else if (_isSecond) {
      final constraintsDiff = areaConstraints *
          (1 - _animationProgress(context)) *
          _animationRate /
          2;
      return Offset(
        constraintsDiff.maxWidth,
        constraintsDiff.maxHeight,
      );
    } else {
      final maxDiff = areaConstraints * _animationRate / 2;
      return Offset(
        maxDiff.maxWidth,
        maxDiff.maxHeight,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final position = _preferredPosition(context);
    return Positioned(
      top: position.dy,
      left: position.dx,
      child: Transform.rotate(
        angle: _rotationAngle,
        origin: _rotationOrigin,
        child: ConstrainedBox(
          constraints: _constraints(context),
          child: IgnorePointer(
            ignoring: !_isFirst,
            child: child,
          ),
        ),
      ),
    );
  }
}
