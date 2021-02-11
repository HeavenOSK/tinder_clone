import 'package:flutter/material.dart';
import 'package:tinder_clone/pages/home/card_builder.dart';
import 'package:tinder_clone/pages/home/controller/swipe_session_state.dart';

extension _Animating on AnimationController {
  bool get animating =>
      status == AnimationStatus.forward || status == AnimationStatus.reverse;
}

typedef CardBuilder = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
);

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  static double swipeThreshold(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.2;

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
    if (!canSwipe) {
      return;
    }

    if (_moveBackAnimationController.animating) {
      _moveBackAnimationController.stop();
    }
    sessionState = sessionState.copyWith(
      localPosition: localPosition,
      startPosition: offset,
      currentPosition: offset,
    );
  }

  void updatePosition({
    @required Offset offset,
    @required Offset localPosition,
  }) {
    if (!canSwipe) {
      return;
    }
    if (_moveBackAnimationController.animating) {
      _moveBackAnimationController.stop();
    }
    sessionState = sessionState.copyWith(
      localPosition: sessionState.localPosition ?? localPosition,
      startPosition: sessionState.startPosition ?? offset,
      currentPosition: offset,
    );
  }

  void leave() {
    if (animating) {
      return;
    }

    final shouldMoveBack =
        _sessionState.diff.dx.abs() <= Home.swipeThreshold(context);
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
      end: sessionState.currentPosition + sessionState.diff * multiple * 1.5,
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
    final diff = sessionState.diff ?? Offset.zero;

    return Scaffold(
      backgroundColor: Colors.lightGreenAccent,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          TextButton(
            onPressed: () {
              sessionState = const SwipeSessionState();
            },
            child: const Text('RESET'),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: kToolbarHeight,
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Positioned(
                      top: diff.dy,
                      left: diff.dx,
                      child: CardBuilderWidget(
                        constraints: constraints,
                        onPanStart: (d) {
                          startToHold(
                            offset: d.globalPosition,
                            localPosition: d.localPosition,
                          );
                          print('globalPosition:${d.globalPosition}, '
                              'localPosition:${d.localPosition}');
                        },
                        onPanUpdate: (d) {
                          updatePosition(
                            offset: d.globalPosition,
                            localPosition: d.localPosition,
                          );
                          // print('globalPosition:${d.globalPosition}, '
                          //     'localPosition:${d.localPosition}');
                          print(_sessionState);
                        },
                        onPanEnd: (d) {
                          leave();
                        },
                        state: _sessionState,
                        builder: (_, constraints) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 20,
                            ),
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: kToolbarHeight,
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
