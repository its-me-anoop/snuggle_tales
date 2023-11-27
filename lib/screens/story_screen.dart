// story_screen.dart
import 'package:flutter/material.dart';
import 'package:snuggle_tales/Utils/footer.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

class StoryScreen extends StatefulWidget {
  final String story;
  final String headerImage;

  const StoryScreen(this.story, this.headerImage, {super.key});

  @override
  StoryScreenState createState() => StoryScreenState();
}

class StoryScreenState extends State<StoryScreen> {
  // Controllers
  late ScrollController _scrollController;

  @override
  void initState() {
    // initialize scroll controllers
    _scrollController = ScrollController();

    super.initState();
    // Fetch image when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: WebSmoothScroll(
          controller: _scrollController,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                  pinned: true,
                  iconTheme: const IconThemeData(color: Colors.white),
                  elevation: 0,
                  expandedHeight: 400,
                  backgroundColor: Colors.black,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      (widget.story.split('\n\n')[0] == "")
                          ? widget.story.split('\n\n')[1]
                          : widget.story.split('\n\n')[0],
                      style: const TextStyle(shadows: [
                        Shadow(color: Colors.black, blurRadius: 10)
                      ], fontWeight: FontWeight.bold),
                    ),
                    background: Image.network(
                      widget.headerImage,
                      isAntiAlias: true,
                      fit: BoxFit.cover,
                    ),
                  )),
              SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.all(
                      (MediaQuery.of(context).size.width) >= 800 ? 50.0 : 20),
                  child: Text(
                    widget.story,
                    style: const TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
                const Footer()
              ]))
            ],
          ),
        ));
  }
}
