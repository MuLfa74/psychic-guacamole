import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'http_cert_client.dart';
import 'api_get_token.dart';

typedef SecureClientFactory = Future<http.Client> Function();

class ModelFetcher {
  final TokenManager tokenManager;
  final SecureClientFactory _clientFactory;

  ModelFetcher(this.tokenManager, {SecureClientFactory? clientFactory})
      : _clientFactory = clientFactory ?? _createSecureClient;

  static Future<http.Client> _createSecureClient() async =>
      IOClient(await createSecureClient());

  Future<List<String>> getModels() async {
    final client = await _clientFactory();
    final token = await tokenManager.getAccessToken();

    final response = await client.get(
      Uri.parse('https://gigachat.devices.sberbank.ru/api/v1/models'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'RqUID': tokenManager.generateRqUID(),
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch models: ${response.body}');
    }

    final json = jsonDecode(response.body);
    return (json['data'] as List)
        .map((e) => e['id'] as String)
        .toList();
  }
}
