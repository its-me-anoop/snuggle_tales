import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle_tales/bloc/story_bloc.dart';
import 'package:snuggle_tales/constants/categories.dart';
import 'package:snuggle_tales/screens/create_story_screen.dart';
import 'package:snuggle_tales/screens/story_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoryBloc>().add(FetchStoriesEvent());
    });
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Snuggle Tales',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) => StoryBloc(),
                            child: const CreateStoryScreen(),
                          )),
                );
              },
              child: const Text('Create Story'),
            ),
          ),
        ],
      ),
      body: BlocBuilder<StoryBloc, StoryState>(
        builder: (context, state) {
          if (state is StoryLoadingState) {
            return const CircularProgressIndicator();
          } else if (state is StoriesLoadedState) {
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, categoryIndex) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 30, bottom: 10),
                      child: Text(
                        categories[categoryIndex],
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 400,
                      child: ListView.builder(
                          itemCount: state.stories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var data = state.stories[index].data()
                                as Map<String, dynamic>;
                            return Padding(
                              padding:
                                  EdgeInsets.only(left: (index == 0) ? 20 : 0),
                              child: (data['storyType'] ==
                                      categories[categoryIndex])
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StoryScreen(
                                                        data['storyContent'],
                                                        data['imageUrl'])));
                                      },
                                      child: Card(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: SizedBox(
                                                width: 250,
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    Image.network(
                                                      data['imageUrl'],
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        child: Text(
                                                          data['storyContent']
                                                              .split('\n\n')
                                                              .first,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.white,
                                                            shadows: [
                                                              Shadow(
                                                                  color: Colors
                                                                      .black,
                                                                  blurRadius:
                                                                      10),
                                                              Shadow(
                                                                  color: Colors
                                                                      .black,
                                                                  blurRadius:
                                                                      10)
                                                            ],
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ))),
                                      ),
                                    )
                                  : const SizedBox(),
                            );
                          }),
                    ),
                    Divider(
                      color: Colors.grey[900],
                    )
                  ],
                );
              },
            );
          } else if (state is StoryErrorState) {
            return const Text('Something went wrong!');
          }
          return const Text('Welcome to Snuggle Tales');
        },
      ),
    );
  }
}
