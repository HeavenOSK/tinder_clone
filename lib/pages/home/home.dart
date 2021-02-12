import 'package:flutter/material.dart';
import 'package:tinder_clone/pages/home/swipable_stack.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _withOpacity = true;
  @override
  Widget build(BuildContext context) {
    final _colors = const [
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
      Color(0xffffd180),
      Color(0xffff9e80),
      Color(0xffff8a80),
      Color(0xffff80ab),
      Color(0xffea80fc),
    ].map((color) => color.withOpacity(_withOpacity ? 0.75 : 1)).toList();
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _withOpacity = !_withOpacity;
                });
              },
              child: const Text('opacity'),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: kToolbarHeight,
          ),
          Expanded(
            child: SwipableStack(
              itemCount: 50,
              cardBuilder: (_, constraints, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _colors[index.abs() % _colors.length],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text('index:$index'),
                    ),
                  ),
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
}
