import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'http_cert_client.dart';
import 'package:uuid/uuid.dart';

typedef SecureClientFactory = Future<http.Client> Function();

class TokenManager {
  String? _accessToken;
  int? _expiresAt;

  final Uuid _uuid;
  final SecureClientFactory _clientFactory;

  TokenManager({SecureClientFactory? clientFactory, Uuid? uuid})
      : _clientFactory = clientFactory ?? _createSecureClient,
        _uuid = uuid ?? const Uuid();

  static Future<http.Client> _createSecureClient() async =>
      IOClient(await createSecureClient());

  Future<String> getAccessToken() async {
    final client = await _clientFactory();

    if (_accessToken != null && _expiresAt != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now < _expiresAt!) return _accessToken!;
    }

    final authKey = dotenv.env['GIGACHAT_APIKEY'];
    if (authKey == null) throw Exception('GIGACHAT_APIKEY not set in .env');

    final response = await client.post(
      Uri.parse('https://ngw.devices.sberbank.ru:9443/api/v2/oauth'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Basic $authKey',
        'RqUID': _uuid.v4(),
      },
      body: {'scope': 'GIGACHAT_API_PERS'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to authorize: ${response.body}');
    }

    final json = jsonDecode(response.body);
    _accessToken = json['access_token'];
    _expiresAt = json['expires_at'];
    return _accessToken!;
  }

  String generateRqUID() => _uuid.v4();
}
