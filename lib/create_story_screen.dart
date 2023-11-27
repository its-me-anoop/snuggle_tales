// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:snuggle_tales/footer.dart';
import 'package:snuggle_tales/story_screen.dart';
import 'package:snuggle_tales/story_service.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  CreateStoryScreenState createState() => CreateStoryScreenState();
}

class CreateStoryScreenState extends State<CreateStoryScreen> {
  List<String> messages = [];
  bool loading = false;

  double selectedAge = 3.0; // Default age range

  String selectedStoryType = 'Adventure'; // Default story type
  String charactersInput =
      'Teddy bear, space ship, fairy tale planet'; // Characters input for the story

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: loading
          ? Center(
              child: Column(
              children: [
                SizedBox(
                  height: 400,
                  width: 400,
                  child: Stack(
                    children: [
                      const SizedBox(
                          height: 400,
                          width: 400,
                          child: RiveAnimation.asset('loader.riv')),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          color: Colors.black,
                          height: 50,
                          width: 200,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 400.0,
                  child: Center(
                    child: DefaultTextStyle(
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      child: AnimatedTextKit(
                        isRepeatingAnimation: true,
                        totalRepeatCount: 10,
                        animatedTexts: [
                          FadeAnimatedText('Unraveling tales...'),
                          FadeAnimatedText('Crafting stories...'),
                          FadeAnimatedText('In the creative forge...'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ))
          : ListView(
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
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                textStyle: MaterialStateProperty.resolveWith(
                                    (states) => const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                backgroundColor: MaterialStateColor.resolveWith(
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

                const Footer()
              ],
            ),
    );
  }

  void createStory() async {
    String compiledMessage =
        "Age ${selectedAge.toInt()} years using $charactersInput";
    String imageQuery = '$charactersInput $selectedStoryType';

    setState(() {
      messages.add(compiledMessage);
      loading = true;
    });

    try {
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
