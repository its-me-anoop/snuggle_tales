import 'package:flutter/material.dart';

/// A simple widget that displays a warning message.
class Warning extends StatelessWidget {
  const Warning({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.red[100],
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              "While AI is powerful, errors may occur. Verify essential information independently.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
