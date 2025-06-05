import 'dart:convert';
import 'http_cert_client.dart';
import 'package:http/io_client.dart';
import 'api_get_token.dart';

class FunctionValidator {
  final TokenManager tokenManager;

  FunctionValidator(this.tokenManager);

  Future<List<String>> validateFunction(Map<String, dynamic> functionJson) async {
    final http = await createSecureClient();
    final client = IOClient(http);
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

    final json = jsonDecode(response.body);
    return (json['errors'] as List).map((e) => e['message'] as String).toList();
  }
}
