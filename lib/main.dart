// Importing necessary packages
import 'package:flutter/material.dart';
import 'package:snuggle_tales/screens/privacy_policy.dart';
import 'screens/create_story_screen.dart';

// Main entry point of the application
void main() {
  runApp(const MyApp());
}

/// The main application widget that sets up the MaterialApp.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App configuration
      title: 'Bedtime Story App',

      // Theme configuration
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),

      // Initial route and route definitions
      initialRoute: '/',
      routes: {
        '/': (context) => const CreateStoryScreen(),
        '/privacy-policy': (context) => const PrivacyPolicy(),
      },
    );
  }
}
