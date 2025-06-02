import 'dart:convert';
import 'package:http/http.dart' as http;
import 'httpTestClient.dart' as httpTest;
import 'api_get_token.dart';

class ModelFetcher {
  final TokenManager tokenManager;

  ModelFetcher(this.tokenManager);

  Future<List<String>> getModels() async {
    final token = await tokenManager.getAccessToken();

    final response = await httpTest.httpClient.get(
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
