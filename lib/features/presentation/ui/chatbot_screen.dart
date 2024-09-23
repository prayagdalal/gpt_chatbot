import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gpt_chatbot/services/chatbot_service.dart';

class ChatbotScreen extends StatefulWidget {
  final ChatbotService chatGPTService;
  final String appBarTitle;
  final String textFieldHint;
  final bool hasBackButton;
  final Color appBarBackgroundColor;
  final BoxDecoration userBubbleDecoration;
  final BoxDecoration botBubbleDecoration;

  const ChatbotScreen({
    Key? key,
    required this.chatGPTService,
    this.hasBackButton = true,
    this.appBarTitle = 'Chat', // Default AppBar title
    this.textFieldHint = 'Ask something...', // Default hint text
    this.appBarBackgroundColor = Colors.blue,
    this.userBubbleDecoration = const BoxDecoration(
      color: Colors.green, // Default user bubble decoration
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    this.botBubbleDecoration = const BoxDecoration(
      color: Colors.grey, // Default bot bubble decoration
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  }) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  void _handleSendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _messageController.clear();
      setState(() {
        _messages.add(ChatMessage(
          message: message,
          isUser: true,
          decoration: widget.userBubbleDecoration,
        ));
      });

      _scrollToBottom(); // Scroll to bottom after sending a message

      // Clear previous bot message if any
      _messages.add(ChatMessage(
        message: '',
        isUser: false,
        decoration: widget.botBubbleDecoration,
      ));

      _scrollToBottom(); // Scroll to bottom when starting to receive the response

      try {
        final Stream<String> stream =
            widget.chatGPTService.streamMessages(message);

        // Listen to the stream directly
        // Inside your stream listener
        stream.listen(
          (content) {
            print('Received chunk: $content'); // Debugging output
            setState(() {
              final index = _messages.length - 1;
              final currentMessage = _messages[index];

              // Append the new content to the existing message
              _messages[index] = ChatMessage(
                message: currentMessage.message + content,
                isUser: false,
                decoration: widget.botBubbleDecoration,
              );
            });
            _scrollToBottom();
          },
          onError: (error) {
            _showErrorSnackbar('Error: ${error.toString()}');
          },
          onDone: () {
            print("Streaming complete");
          },
        );
      } catch (e) {
        // Show snackbar for errors
        _showErrorSnackbar('Error: ${e.toString()}');
      }
    }
  }

  void _showErrorSnackbar(String message) {
    // Ensure this is called after the widget tree is built
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.hasBackButton,
        backgroundColor: widget.appBarBackgroundColor,
        title: Text(widget.appBarTitle), // Dynamic AppBar title
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            key: ValueKey(_messages.length), // Ensure it rebuilds
            controller: _scrollController,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return ChatBubble(message: message);
            },
          )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: widget.textFieldHint, // Dynamic hint text
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _handleSendMessage,
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isUser;
  final BoxDecoration decoration;

  const ChatMessage({
    required this.message,
    required this.isUser,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: decoration, // Dynamic decoration for user/bot messages
        child: Text(message),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: message.decoration, // Use the provided decoration
        child: Text(
          message.message,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
