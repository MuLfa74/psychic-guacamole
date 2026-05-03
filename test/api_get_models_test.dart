import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_application_ai_chat/features/chat/data/datasources/api_get_models.dart';
import 'package:flutter_application_ai_chat/features/chat/data/datasources/api_get_token.dart';

void main() {
  setUp(() {
    dotenv.env.clear();
    dotenv.env['GIGACHAT_APIKEY'] = 'test-key';
  });

  test('returns model ids when API responds with 200', () async {
    final tokenClient = MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.url.path, '/api/v2/oauth');
      return http.Response(
        jsonEncode({
          'access_token': 'test-token',
          'expires_at': DateTime.now().millisecondsSinceEpoch + 10000,
        }),
        200,
      );
    });

    final modelClient = MockClient((request) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/api/v1/models');
      expect(request.headers['Authorization'], 'Bearer test-token');
      return http.Response(
        jsonEncode({
          'data': [
            {'id': 'GigaChat'},
            {'id': 'GigaChat-Pro'},
          ],
        }),
        200,
      );
    });

    final tokenManager = TokenManager(clientFactory: () async => tokenClient);
    final fetcher = ModelFetcher(
      tokenManager,
      clientFactory: () async => modelClient,
    );

    final models = await fetcher.getModels();

    expect(models, ['GigaChat', 'GigaChat-Pro']);
  });

  test('throws when server returns non-200 status', () async {
    final tokenClient = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'access_token': 'test-token',
          'expires_at': DateTime.now().millisecondsSinceEpoch + 10000,
        }),
        200,
      );
    });

    final modelClient = MockClient((request) async {
      return http.Response('Bad request', 400);
    });

    final tokenManager = TokenManager(clientFactory: () async => tokenClient);
    final fetcher = ModelFetcher(
      tokenManager,
      clientFactory: () async => modelClient,
    );

    expect(
      fetcher.getModels(),
      throwsA(
        isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed to fetch models'),
        ),
      ),
    );
  });
}
