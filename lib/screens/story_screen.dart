import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  late ScrollController _scrollController;
  late FlutterTts flutterTts;
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    initTts();
  }

  void initTts() {
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      setState(() => isSpeaking = true);
    });

    flutterTts.setCompletionHandler(() {
      setState(() => isSpeaking = false);
    });

    flutterTts.setErrorHandler((msg) {
      setState(() => isSpeaking = false);
      // Optionally handle TTS errors here
    });
  }

  Future speak() async {
    if (widget.story.isNotEmpty) {
      await flutterTts.speak(widget.story);
    }
  }

  Future stop() async {
    await flutterTts.stop();
    setState(() => isSpeaking = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  TextStyle _dynamicTextStyle(BuildContext context) {
    double baseFontSize = 18.0;
    double scalingFactor = 0.05;
    double scaledFontSize =
        MediaQuery.of(context).textScaler.scale(baseFontSize) * scalingFactor;
    return TextStyle(
        fontSize: baseFontSize * scaledFontSize, color: Colors.white);
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
                  widget.story.split('\n\n').first,
                  style: const TextStyle(
                    shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Image.network(
                  widget.headerImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.all(
                      (MediaQuery.of(context).size.width) >= 800 ? 50.0 : 20),
                  child: Text(
                    widget.story,
                    style: _dynamicTextStyle(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: isSpeaking ? stop : speak,
                      child: Text(isSpeaking ? 'Stop Reading' : 'Read Aloud'),
                    ),
                  ),
                ),
                const Footer(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
