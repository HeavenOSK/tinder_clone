import 'package:flutter/material.dart';
import 'package:tinder_clone/pages/home/home.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => Home(),
                ),
              );
            },
            child: Text('Navigate to HOME'),
          ),
        ),
      ),
    );
  }
}
