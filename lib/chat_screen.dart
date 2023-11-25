import 'package:flutter/material.dart';
import 'chat_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _controller = TextEditingController();
  List<String> messages = [];
  bool loading = false; // Added loading state variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bedtime Story Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          if (loading) // Display the loader conditionally
            CircularProgressIndicator()
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      sendMessage();
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void sendMessage() async {
    String userMessage = _controller.text;
    _controller.clear();

    setState(() {
      messages.add('User: $userMessage');
      loading = true; // Set loading to true when sending a message
    });

    try {
      String response = await getChatGPTResponse(userMessage);
      setState(() {
        messages.add('ChatGPT: $response');
      });
    } catch (e) {
      print('Error getting ChatGPT response: $e');
    } finally {
      setState(() {
        loading =
            false; // Set loading to false after getting the response or in case of an error
      });
    }
  }
}
