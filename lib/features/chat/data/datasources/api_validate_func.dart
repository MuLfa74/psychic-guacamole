import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'api_get_token.dart';
import 'http_cert_client.dart';

typedef SecureClientFactory = Future<http.Client> Function();

class FunctionValidator {
  final TokenManager tokenManager;
  final SecureClientFactory _clientFactory;

  FunctionValidator(this.tokenManager, {SecureClientFactory? clientFactory})
      : _clientFactory = clientFactory ?? _createSecureClient;

  static Future<http.Client> _createSecureClient() async =>
      IOClient(await createSecureClient());

  Future<List<String>> validateFunction(Map<String, dynamic> functionJson) async {
    final client = await _clientFactory();
    final token = await tokenManager.getAccessToken();

    final response = await client.post(
      Uri.parse('https://gigachat.devices.sberbank.ru/api/v1/functions/validation'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'RqUID': tokenManager.generateRqUID(),
      },
      body: jsonEncode({"functions": [functionJson]}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to validate function: ${response.body}');
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    return (json['errors'] as List).map((e) => e['message'] as String).toList();
  }
}
