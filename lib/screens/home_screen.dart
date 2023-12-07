import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle_tales/bloc/story_bloc.dart';
import 'package:snuggle_tales/screens/create_story_screen.dart';
import 'package:snuggle_tales/screens/story_screen.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _verticalScrollController;
  late ScrollController _horizontalScrollController;

  @override
  void initState() {
    super.initState();
    _verticalScrollController = ScrollController();
    _horizontalScrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoryBloc>().add(FetchStoriesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoryBloc>().add(FetchStoriesEvent());
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Snuggle Tales',
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: () {
                BlocProvider(
                  create: (context) => StoryBloc(),
                  child: _openCreateStoryBottomSheet(context),
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
            //Categories section
            return WebSmoothScroll(
              controller: _verticalScrollController,
              child: ListView.builder(
                controller: _verticalScrollController,
                itemCount: state.genres.length,
                itemBuilder: (context, genreIndex) {
                  var genres =
                      state.genres[genreIndex].data() as Map<String, dynamic>;
                  return Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          Colors.white,
                          Color.fromARGB(255, 227, 225, 225)
                        ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Category Title
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 30, bottom: 10),
                          child: Text(
                            genres['genre'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: WebSmoothScroll(
                            controller: _horizontalScrollController,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: ListView.builder(
                                  controller: _horizontalScrollController,
                                  itemCount: state.stories.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    var data = state.stories[index].data()
                                        as Map<String, dynamic>;

                                    // Stories based on category
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: (index == 0) ? 20 : 0),
                                      child: (data['genre'] == genres['genre'])
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            StoryScreen(
                                                                data[
                                                                    'storyContent'],
                                                                data[
                                                                    'imageUrl'])));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10)),
                                                    child: SizedBox(
                                                        width: 200,
                                                        child: Stack(
                                                          fit: StackFit.expand,
                                                          children: [
                                                            Hero(
                                                              tag: data[
                                                                  'imageUrl'],
                                                              child:
                                                                  Image.network(
                                                                data[
                                                                    'imageUrl'],
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        20.0),
                                                                child: Text(
                                                                  data['storyContent']
                                                                      .split(
                                                                          '\n\n')
                                                                      .first,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .white,
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
                                                                        FontWeight
                                                                            .bold,
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
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else if (state is StoryErrorState) {
            return const Text('Something went wrong!');
          }
          return const Text('Welcome to Snuggle Tales');
        },
      ),
    );
  }

  _openCreateStoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      constraints: const BoxConstraints(maxWidth: 400, maxHeight: 300),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => StoryBloc(),
          child: CreateStoryScreen(
            onStoryCreated: () => Navigator.pop(context),
          ),
        ); // Your CreateStoryScreen widget
      },
    );
  }
}
