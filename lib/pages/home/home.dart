import 'package:flutter/material.dart';
import 'package:tinder_clone/pages/home/swipable_stack.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreenAccent,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        actions: [
          TextButton(
            onPressed: () {},
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
            child: SwipableStack(
              cardBuilder: (_, constraints) {
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
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          print('pressed');
                        },
                        child: Icon(Icons.stop),
                      ),
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
