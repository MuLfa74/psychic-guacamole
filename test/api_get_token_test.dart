import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_application_ai_chat/features/chat/data/datasources/api_get_token.dart';

void main() {
  setUp(() {
    dotenv.env.clear();
  });

  test('throws when GIGACHAT_APIKEY is not set', () async {
    final tokenManager = TokenManager(
      clientFactory: () async => MockClient((request) async {
        return http.Response('', 200);
      }),
    );

    expect(
      tokenManager.getAccessToken(),
      throwsA(
        isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('GIGACHAT_APIKEY not set'),
        ),
      ),
    );
  });

  test('returns access token and caches it', () async {
    dotenv.env['GIGACHAT_APIKEY'] = 'test-key';
    var authCallCount = 0;

    final clientFactory = () async => MockClient((request) async {
      authCallCount += 1;
      expect(request.method, 'POST');
      expect(request.url.path, '/api/v2/oauth');

      return http.Response(
        jsonEncode({
          'access_token': 'token-1',
          'expires_at': DateTime.now().millisecondsSinceEpoch + 10000,
        }),
        200,
      );
    });

    final tokenManager = TokenManager(clientFactory: clientFactory);

    final firstToken = await tokenManager.getAccessToken();
    final secondToken = await tokenManager.getAccessToken();

    expect(firstToken, 'token-1');
    expect(secondToken, 'token-1');
    expect(authCallCount, 1);
  });
}
