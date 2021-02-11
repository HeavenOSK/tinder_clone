import 'package:flutter/material.dart';
import 'package:tinder_clone/pages/home/controller/swipe_session_state.dart';
import 'package:tinder_clone/pages/home/frame.dart';
import 'package:tinder_clone/pages/home/user_card.dart';

extension _Animating on AnimationController {
  bool get animating =>
      status == AnimationStatus.forward || status == AnimationStatus.reverse;
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
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

  static Offset defaultPosition(BuildContext context) => Offset(
        UserCard.padding.left,
        Frame.topPadding(context) + UserCard.padding.top,
      );

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
    if (canSwipe) {
      if (_moveBackAnimationController.animating) {
        _moveBackAnimationController.stop();
      }
      sessionState = sessionState.copyWith(
        localPosition: localPosition,
        startPosition: offset,
        currentPosition: offset,
      );
    }
  }

  void updatePosition({
    @required Offset offset,
    @required Offset localPosition,
  }) {
    if (canSwipe) {
      if (_moveBackAnimationController.animating) {
        _moveBackAnimationController.stop();
      }
      sessionState = sessionState.copyWith(
        localPosition: sessionState.localPosition ?? localPosition,
        startPosition: sessionState.startPosition ?? offset,
        currentPosition: offset,
      );
    }
  }

  void leave() {
    if (animating) {
      return;
    }

    final width = MediaQuery.of(context).size.width;

    final shouldMoveBack = _sessionState.diff.dx.abs() <= width * 0.25;
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
      end: sessionState.currentPosition + sessionState.diff * multiple * 2,
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
    final position = defaultPosition(context);
    final diff = sessionState.diff ?? Offset.zero;
    return Frame(
      onReset: () {
        sessionState = const SwipeSessionState();
      },
      body: Stack(
        children: [
          Positioned(
            top: position.dy + diff.dy,
            left: position.dx + diff.dx,
            child: UserCard(
              onPanStart: (d) {
                startToHold(
                  offset: d.globalPosition,
                  localPosition: d.localPosition,
                );
                print(d);
              },
              onPanUpdate: (d) {
                updatePosition(
                  offset: d.globalPosition,
                  localPosition: d.localPosition,
                );
              },
              onPanEnd: (d) {
                leave();
                print(d.velocity.pixelsPerSecond.dx);
              },
              state: _sessionState,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _moveBackAnimationController?.dispose();
    _swipeAssistAnimationController?.dispose();
    super.dispose();
  }
}
