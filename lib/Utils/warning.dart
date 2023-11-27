import 'package:flutter/material.dart';

class Warning extends StatelessWidget {
  const Warning({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(30.0),
      child: Text(
        "AI can make mistakes. Consider checking important information.",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
