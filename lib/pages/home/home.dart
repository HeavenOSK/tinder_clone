import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tinder_clone/pages/home/card_label.dart';
import 'package:tinder_clone/pages/home/swipable_stack.dart';
import 'package:tinder_clone/pages/home/swipable_stack_controller.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final double _bottomAreaHeight = 100;
  SwipableStackController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController();
  }

  @override
  Widget build(BuildContext context) {
    final _colors = const [
      Color(0xffffd180),
      Color(0xffff9e80),
      Color(0xffff8a80),
      Color(0xffff80ab),
      Color(0xffea80fc),
      Color(0xffb388ff),
      Color(0xff8c9eff),
      Color(0xff82b1ff),
      Color(0xff80d8ff),
      Color(0xff84ffff),
      Color(0xffa7ffeb),
      Color(0xffb9f6ca),
      Color(0xffccff90),
      Color(0xffffff8d),
      Color(0xffffe57f),
    ].map((color) => color.withOpacity(0.75)).toList();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SwipableStack(
              controller: _controller,
              onSwipeCompleted: (index, direction) {
                print('$index, $direction');
              },
              overlayBuilder: (alignmentPerThreshold) {
                print(alignmentPerThreshold.x);
                final isRight = alignmentPerThreshold.x > 0;
                final opacity = min<double>(alignmentPerThreshold.x.abs(), 1);
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: _bottomAreaHeight,
                    horizontal: 16,
                  ),
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: isRight ? opacity : 0,
                        child: CardLabel.like(),
                      ),
                      Opacity(
                        opacity: !isRight ? opacity : 0,
                        child: CardLabel.nope(),
                      ),
                    ],
                  ),
                );
              },
              builder: (_, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: _bottomAreaHeight,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          // color: _colors[index.abs() % _colors.length],
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2,
                              color: Colors.black.withOpacity(0.15),
                              offset: Offset(0, 1),
                            ),
                            BoxShadow(
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text('index:$index'),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: _bottomAreaHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 64,
                      width: 64,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.resolveWith(
                            (states) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        onPressed: () {
                          _controller.moveNext(SwipeDirection.left);
                        },
                        child: const Icon(Icons.navigate_before),
                      ),
                    ),
                    const SizedBox(width: 120),
                    SizedBox(
                      height: 64,
                      width: 64,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.resolveWith(
                            (states) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        onPressed: () {
                          _controller.moveNext(SwipeDirection.right);
                        },
                        child: const Icon(Icons.navigate_next),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
