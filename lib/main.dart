import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle_tales/bloc/story_bloc.dart';
import 'package:snuggle_tales/firebase_options.dart';
import 'package:snuggle_tales/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snuggle Tales',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: BlocProvider(
        create: (context) => StoryBloc()..add(FetchStoriesEvent()),
        child: const HomeScreen(),
      ),
    );
  }
}
