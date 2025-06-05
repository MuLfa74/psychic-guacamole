import 'dart:convert';
import 'package:http/io_client.dart';
import 'http_cert_client.dart';
import 'api_get_token.dart';

class ModelFetcher {
  final TokenManager tokenManager;

  ModelFetcher(this.tokenManager);

  Future<List<String>> getModels() async {
    final http = await createSecureClient();
    final client = IOClient(http);
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
