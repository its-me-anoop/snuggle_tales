// story_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class StoryScreen extends StatefulWidget {
  final String story;
  final String headerImage;

  const StoryScreen(this.story, this.headerImage, {super.key});

  @override
  StoryScreenState createState() => StoryScreenState();
}

class StoryScreenState extends State<StoryScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch image when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
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
                    style: const TextStyle(
                        shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                        fontWeight: FontWeight.bold),
                  ),
                  background: Image.network(
                    widget.headerImage,
                    fit: BoxFit.cover,
                  ),
                )),
            SliverList(
                delegate: SliverChildListDelegate([
              const HtmlWidget('''
<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-6339114301652266"
     crossorigin="anonymous"></script>
<!-- horizontal banner -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-6339114301652266"
     data-ad-slot="4955872269"
     data-ad-format="auto"
     data-full-width-responsive="true"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>
'''),
              Padding(
                padding: EdgeInsets.all(
                    (MediaQuery.of(context).size.width) >= 800 ? 50.0 : 20),
                child: Text(
                  widget.story,
                  style: const TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 400,
                child: HtmlWidget(
                    ''' <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-6339114301652266"
                   crossorigin="anonymous"></script>
              <ins class="adsbygoogle"
                   style="display:block"
                   data-ad-format="autorelaxed"
                   data-ad-client="ca-pub-6339114301652266"
                   data-ad-slot="6524992859"></ins>
              <script>
                   (adsbygoogle = window.adsbygoogle || []).push({});
              </script>'''),
              )
            ]))
          ],
        ));
  }
}
