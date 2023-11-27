// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:snuggle_tales/Utils/loader.dart';
import 'package:snuggle_tales/Utils/footer.dart';
import 'package:snuggle_tales/Services/story_service.dart';
import 'package:snuggle_tales/Utils/warning.dart';
import 'package:snuggle_tales/screens/story_screen.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

/// The CreateStoryScreen widget where users can create a story.
class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  CreateStoryScreenState createState() => CreateStoryScreenState();
}

class CreateStoryScreenState extends State<CreateStoryScreen> {
  List<String> messages = [];
  bool loading = false;

  // Controllers
  late ScrollController _scrollController;

  double selectedAge = 3.0; // Default age range

  String selectedStoryType = 'Adventure'; // Default story type
  String charactersInput =
      'Teddy bear, space ship, fairy tale planet'; // Characters input for the story

  @override
  void initState() {
    // initialize scroll controllers
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: loading
          ? const Loader()
          : WebSmoothScroll(
              controller: _scrollController,
              child: ListView(
                controller: _scrollController,
                children: [
                  //Header Image
                  SizedBox(
                    height: 400,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'header.jpg',
                          height: 400,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                  // Options Section
                  Center(
                    child: Container(
                      width: 500,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Age Slider
                          Text(
                            'Select Child\'s Age: ${selectedAge.toInt()} years',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Slider(
                            thumbColor: Colors.amber[900],
                            activeColor: Colors.amber[600],
                            inactiveColor: Colors.amber[200],
                            value: selectedAge,
                            onChanged: (double value) {
                              setState(() {
                                selectedAge = value;
                              });
                            },
                            min: 0.0,
                            max: 13.0,
                            divisions: 13,
                            label: selectedAge.toInt().toString(),
                          ),
                          const SizedBox(height: 10.0),
                          // Theme Dropdown
                          Row(
                            children: [
                              const Text(
                                'Theme:',
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              DropdownButton<String>(
                                iconEnabledColor: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                style: const TextStyle(color: Colors.white),
                                underline: const SizedBox(),
                                value: selectedStoryType,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedStoryType = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Adventure',
                                  'Fantasy',
                                  'Mystery',
                                  'Fairy Tale',
                                  'Halloween',
                                  'Christmas',
                                  'Funny',
                                  'Outer Space',
                                  'Sci-fi',
                                  'Super Heroes'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          color: Colors.amber[900],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          // Characters Input Field
                          TextField(
                            style: TextStyle(
                                color: Colors.amber[900],
                                fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(
                                focusColor: Colors.amber,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.amber),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                labelText:
                                    'Characters, props or special instructions for the Story',
                                hintText:
                                    'Teddy bear, space ship, fairy tale planet...',
                                fillColor: Colors.amber,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.amber),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                labelStyle: TextStyle(color: Colors.white),
                                hintStyle: TextStyle(color: Colors.grey)),
                            onChanged: (value) {
                              setState(() {
                                charactersInput = value;
                              });
                            },
                          ),
                          // Create Story Button
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  textStyle: MaterialStateProperty.resolveWith(
                                      (states) => const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.amber)),
                              onPressed: () {
                                createStory();
                              },
                              child: const Text('Create Story'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Chat Section
                  const Warning(),
                  const Footer()
                ],
              ),
            ),
    );
  }

  /// Generates and displays a story based on user input.
  void createStory() async {
    String compiledMessage =
        "Age ${selectedAge.toInt()} years using $charactersInput";
    String imageQuery = '$charactersInput $selectedStoryType';

    setState(() {
      messages.add(compiledMessage);
      loading = true;
    });

    try {
      // Fetch response from ChatGPT and image response
      String response = await getChatGPTResponse(compiledMessage);
      String imageResponse = await getImageResponse(imageQuery);

      setState(() {
        messages.add(response);
      });

      // Navigate to the StoryScreen with the generated story
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StoryScreen(response, imageResponse)),
      );
    } catch (e) {
      // Handle error while getting ChatGPT response
      if (kDebugMode) {
        print('Error getting ChatGPT response: $e');
      }
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}
