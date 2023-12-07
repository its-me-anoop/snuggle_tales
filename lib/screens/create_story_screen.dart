import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle_tales/bloc/story_bloc.dart';
import 'package:snuggle_tales/screens/story_screen.dart';
import 'package:snuggle_tales/Utils/loader.dart';
import 'package:snuggle_tales/Utils/warning.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

class CreateStoryScreen extends StatefulWidget {
  final VoidCallback onStoryCreated; // Add this line
  const CreateStoryScreen({super.key, required this.onStoryCreated});

  @override
  CreateStoryScreenState createState() => CreateStoryScreenState();
}

class CreateStoryScreenState extends State<CreateStoryScreen> {
  late ScrollController _scrollController;
  String storyPrompt = 'story from the bible';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<StoryBloc, StoryState>(
        listener: (context, state) {
          if (state is StoryLoadedState) {
            widget.onStoryCreated(); // Add this line to trigger the callback
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    StoryScreen(state.storyContent, state.imageUrl),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is StoryLoadingState) {
            return const Loader();
          }

          return WebSmoothScroll(
            controller: _scrollController,
            child: ListView(
              controller: _scrollController,
              children: [
                // Options Section
                Center(
                  child: Container(
                    width: 500,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Characters Input Field
                        SizedBox(
                          height: 100,
                          child: TextField(
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            style: TextStyle(
                                color: Colors.amber[900],
                                fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(
                              focusColor: Colors.amber,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              labelText: 'Describe your story',
                              hintText:
                                  'Teddy bear, space ship, fairy tale planet...',
                              fillColor: Colors.amber,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            onChanged: (value) {
                              setState(() {
                                storyPrompt = value;
                              });
                            },
                          ),
                        ),
                        // Create Story Button
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  textStyle: MaterialStateProperty.resolveWith(
                                      (states) => const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.amber)),
                              onPressed: () {
                                BlocProvider.of<StoryBloc>(context).add(
                                  StoryCreateEvent(storyPrompt),
                                );
                              },
                              child: const Text(
                                'Create Story',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        // Create Story Button
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Chat Section
                const Warning(),
              ],
            ),
          );
        },
      ),
    );
  }
}
