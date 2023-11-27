// Importing necessary packages
import 'package:flutter/material.dart';
import 'package:snuggle_tales/privacy_policy.dart';
import 'create_story_screen.dart';

// Main entry point of the application
void main() {
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App configuration
      title: 'Bedtime Story App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CreateStoryScreen(),
        '/privacy-policy': (context) => const PrivacyPolicy(),
      },
    );
  }
}
