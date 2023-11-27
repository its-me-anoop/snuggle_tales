// footer.dart
import 'package:flutter/material.dart';

/// The Footer widget displays a link to the privacy policy.
class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/privacy-policy');
            },
            child: const Text(
              'Privacy Policy',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
