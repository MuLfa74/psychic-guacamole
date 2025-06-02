import 'dart:convert';
import 'package:http/http.dart' as http;
import 'httpTestClient.dart' as httpTest;

import 'api_get_token.dart';
import 'api_get_models.dart';
import 'api_validate_func.dart';

class ChatApiDataSource {
  final TokenManager _tokenManager = TokenManager();

  late final ModelFetcher _modelFetcher = ModelFetcher(_tokenManager);
  late final FunctionValidator _validator = FunctionValidator(_tokenManager);

  Future<List<String>> getAvailableModels() => _modelFetcher.getModels();

  Future<List<String>> validateFunction(Map<String, dynamic> json) =>
      _validator.validateFunction(json);

  Future<String> sendMessage(String userMessage) async {
    final token = await _tokenManager.getAccessToken();

    final response = await httpTest.httpClient.post(
      Uri.parse('https://gigachat.devices.sberbank.ru/api/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'RqUID': _tokenManager.generateRqUID(),
      },
      body: jsonEncode({
        "model": "GigaChat",
        "messages": [
          {
            "role": "user",
            "content": userMessage,
          }
        ],
        "temperature": 1,
        "top_p": 0.9,
        "n": 1,
        "stream": false,
      }),
      encoding: utf8,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get chat response: ${response.body}');
    }

    final json = jsonDecode(response.body);
    return json['choices'][0]['message']['content'] as String;
  }
}
