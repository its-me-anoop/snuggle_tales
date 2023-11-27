import 'package:flutter/material.dart';

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
