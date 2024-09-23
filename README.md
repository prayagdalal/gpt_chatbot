# GPT Chatbot

`gpt_chatbot` is a highly customizable and easy-to-use Flutter package that enables developers to integrate a smart chat interface powered by OpenAI's GPT models into their Flutter applications. The package provides a ready-made chat UI and handles interaction with the GPT API, allowing you to create intelligent conversational agents with minimal effort.

## Features

- **Customizable Chat Interface**: Style the chat bubbles, app bar, and input field to match your app’s theme.
- **Real-time Streaming**: Stream messages from the AI in real-time, simulating natural typing behavior.
- **Auto Scrolling**: The chat interface automatically scrolls with new messages for a seamless user experience.
- **Easy Integration**: Integrate GPT-based chat into your app with minimal code.
- **Supports GPT-3.5-turbo and GPT-4o-mini**: Designed to work with OpenAI’s GPT-3.5-turbo model by default, with support for other models.
- **Flexible Chatbots**: Create adaptable chatbots for various applications by setting specific system prompts.

## Installation

Add `gpt_chatbot` to your `pubspec.yaml`:

```yaml
dependencies:
  gpt_chatbot: ^0.0.1
```

## Usage

To get started with `gpt_chatbot`, use the following example code:

```dart
import 'package:flutter/material.dart';
import 'package:gpt_chatbot/gpt_chatbot.dart';

class MyChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatGPTService = ChatbotService(
      apiKey: 'your-openai-api-key',
      systemPrompt: 'You are a helpful Dietitian Nutritionist. Provide information about diet, food, workout, and nutritional facts.',
      temperature: 0.5, // Custom temperature setting
      maxTokens: 6000, // Custom max tokens
      model: 'gpt-4o-mini', // Specify a different model if needed
    );

    return ChatbotScreen(
      chatGPTService: chatGPTService,
      appBarTitle: 'Health Chatbot',
      hasBackButton: false,
      appBarBackgroundColor: Colors.pink, // Custom app bar color
      textFieldHint: 'Ask your question...',
      userBubbleDecoration: BoxDecoration(
        color: Colors.pinkAccent, // Custom user bubble color
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      botBubbleDecoration: BoxDecoration(
        color: Color.fromARGB(255, 220, 220, 220), // Custom bot bubble color
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
```

## Demo

![Output 1](https://github.com/user-attachments/assets/f51a1b20-ccd4-462f-b2d7-d56fc0f6507a)
![Output 2](https://github.com/user-attachments/assets/3b66ab59-b282-4a6b-8c60-9772c8fd6bb9)

<table>
  <tr>
    <td><img src="https://github.com/mdazharuddin1011999/UPI-Plugin-Flutter/raw/master/images/success.jpg" alt="Success Status" width="200"></td>
    <td><img src="https://github.com/mdazharuddin1011999/UPI-Plugin-Flutter/raw/master/images/show.gif" alt="How example looks" width="200"></td>
  </tr>
</table>

## API Documentation

### `ChatbotService`

- **`ChatbotService`**: Manages interaction with the OpenAI GPT model.

  **Constructor:**
  - `ChatbotService({required String apiKey, required String systemPrompt, double temperature = 0.5, int maxTokens = 1500, String model = 'gpt-4o-mini'})`

  **Methods:**
  - `Stream<String> streamMessages(String message)`: Streams responses from the GPT model in real-time.

### `ChatbotScreen`

- **`ChatbotScreen`**: A widget that provides a chat interface integrated with GPT.

  **Constructor:**
  - `ChatbotScreen({required ChatbotService chatGPTService, String appBarTitle = 'Chat', String textFieldHint = 'Ask something...', BoxDecoration userBubbleDecoration = const BoxDecoration(), BoxDecoration botBubbleDecoration = const BoxDecoration()})`

  **Parameters:**
  - `chatGPTService`: An instance of `ChatbotService`.
  - `appBarTitle`: Title for the AppBar.
  - `hasBackButton`: Show or hide the back button in the app bar.
  - `appBarBackgroundColor`: Background color for the app bar.
  - `textFieldHint`: Hint text for the text field.
  - `userBubbleDecoration`: Decoration for user messages.
  - `botBubbleDecoration`: Decoration for bot messages.

## Configuration

Configure the `ChatbotService` with your OpenAI API key and customize the chat behavior by adjusting parameters like `systemPrompt`, `temperature`, `maxTokens`, and `model`.

## If You Find This Package Helpful

[Support Me](https://paypal.me/prayagdalal11?country.x=IN&locale.x=en_GB) | 
[LinkedIn](https://www.linkedin.com/in/prayagdalal/) | 
[X](https://x.com/prayag_dalal) | 
[Have a Project?](https://calendly.com/prayagdalal1111/30min) 
