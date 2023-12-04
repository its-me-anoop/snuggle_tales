import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle_tales/bloc/story_bloc.dart';
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
              itemCount: state.stories.length,
              itemBuilder: (context, index) {
                var data = state.stories[index].data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoryScreen(
                                  data['storyContent'], data['imageUrl'])));
                    },
                    child: Card(
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: SizedBox(
                        height: 200,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                              child: SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: Image.network(
                                    data['imageUrl'],
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['storyContent'].split('\n\n').first,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Age :',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              data['age'].toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Category :',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            data['storyType'].toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Tags :',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            data['characters'].toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
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
