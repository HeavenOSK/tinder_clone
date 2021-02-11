import 'package:flutter/material.dart';

class Frame extends StatelessWidget {
  const Frame({
    @required this.body,
    @required this.onReset,
    Key key,
  }) : super(key: key);

  final Widget body;
  final VoidCallback onReset;
  static const double bottomPadding = kToolbarHeight * 1.2;
  static double topPadding(BuildContext context) =>
      MediaQuery.of(context).padding.top + kToolbarHeight * 1.2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.lightBlueAccent.withOpacity(0.75),
            ),
          ),
          Container(
            height: topPadding(context),
            width: double.infinity,
            color: Colors.transparent,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(8),
            child: TextButton(
              onPressed: onReset,
              child: const Text('RESET'),
            ),
          ),
          body,
        ],
      ),
    );
  }
}
