import 'package:flutter/material.dart';

/// A simple widget that displays a warning message.
class Warning extends StatelessWidget {
  const Warning({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(30.0),
        child: Text(
          "While AI is powerful, errors may occur. Verify essential information independently.",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
