import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'api_get_token.dart';
import 'api_get_models.dart';
import 'api_validate_func.dart';
import 'http_cert_client.dart';

typedef SecureClientFactory = Future<http.Client> Function();

class ChatApiDataSource {
  final TokenManager _tokenManager;
  final SecureClientFactory _clientFactory;
  late final ModelFetcher _modelFetcher;
  late final FunctionValidator _validator;

  ChatApiDataSource({
    TokenManager? tokenManager,
    ModelFetcher? modelFetcher,
    FunctionValidator? validator,
    SecureClientFactory? clientFactory,
  })  : _clientFactory = clientFactory ?? _createSecureClient,
        _tokenManager = tokenManager ?? TokenManager(clientFactory: clientFactory) {
    _modelFetcher =
        modelFetcher ?? ModelFetcher(_tokenManager, clientFactory: clientFactory);
    _validator =
        validator ?? FunctionValidator(_tokenManager, clientFactory: clientFactory);
  }

  static Future<http.Client> _createSecureClient() async =>
      IOClient(await createSecureClient());

  Future<List<String>> getAvailableModels() => _modelFetcher.getModels();

  Future<List<String>> validateFunction(Map<String, dynamic> json) =>
      _validator.validateFunction(json);

  Future<String> sendMessage(String userMessage) async {
    final client = await _clientFactory();
    final token = await _tokenManager.getAccessToken();

    final response = await client.post(
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
