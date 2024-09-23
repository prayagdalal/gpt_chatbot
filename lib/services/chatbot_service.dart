import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  final String apiKey;
  final String systemPrompt;
  final double temperature;
  final int maxTokens;
  final String model;

  ChatbotService({
    required this.apiKey,
    required this.systemPrompt,
    this.temperature = 0.7,
    this.maxTokens = 4000, // Default max tokens
    this.model = 'gpt-3.5-turbo', // Default model
  });

  Stream<String> streamMessages(String message) async* {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final userContent = message +
        '\n\nPlease respond in simple plain text. Avoid using any bold, italics, headings, or special formatting. Make sure to use proper line breaks and include bullet points where necessary for lists.';

    final body = jsonEncode({
      'model': model,
      'messages': [
        {
          'role': 'user',
          'content': userContent,
        },
        {'role': 'system', 'content': systemPrompt},
      ],
      'temperature': temperature,
      'max_tokens': maxTokens,
      'stream': true, // Enable streaming
    });

    final request = http.Request('POST', url)
      ..headers.addAll(headers)
      ..body = body;

    try {
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        String buffer = ''; // Buffer to store parts of the message

        await for (var chunk in streamedResponse.stream) {
          final chunkString = utf8.decode(chunk);
          final lines = chunkString.split('\n');

          for (var line in lines) {
            if (line.isNotEmpty && line.startsWith('data: ')) {
              final jsonLine = line.substring(6); // Remove 'data: '
              if (jsonLine == '[DONE]') {
                yield buffer; // Yield the full message
                return; // End the stream
              }

              try {
                final parsed = jsonDecode(jsonLine);
                if (parsed['choices'] != null && parsed['choices'].isNotEmpty) {
                  final content =
                      parsed['choices'][0]['delta']['content'] ?? '';

                  buffer += content; // Add new content to the buffer

                  if (content.contains('\n')) {
                    yield buffer; // Yield full message if it contains a newline
                    buffer = ''; // Clear the buffer after yielding
                  }
                }
              } catch (e) {
                throw Exception('Streaming error: ${e.toString()}');
              }
            }
          }
        }
      } else {
        throw Exception('Error: ${streamedResponse.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Streaming error: ${e.toString()}');
    }
  }
}
