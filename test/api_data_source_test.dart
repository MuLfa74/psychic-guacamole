import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_application_ai_chat/features/chat/data/datasources/api_data_source.dart';
import 'package:flutter_application_ai_chat/features/chat/domain/entities/chat_request.dart';
import 'package:flutter_application_ai_chat/features/chat/domain/entities/chat_message.dart';
import 'package:flutter_application_ai_chat/features/chat/domain/enums/chat_role.dart';
import 'package:flutter_application_ai_chat/features/chat/domain/enums/chat_message_type.dart';

void main() {
  dotenv.load();
  test('sendMessage returns ChatResponse with assistant content', () async {
    final clientFactory = () async => MockClient((request) async {
      if (request.url.path == '/api/v2/oauth') {
        return http.Response(
          jsonEncode({
            'access_token': 'test-token',
            'expires_at': DateTime.now().millisecondsSinceEpoch + 10000,
          }),
          200,
        );
      }

      expect(request.method, 'POST');
      expect(request.url.path, '/api/v1/chat/completions');
      expect(request.headers['Authorization'], 'Bearer test-token');
      final responseBody = jsonEncode({
        'choices': [
          {
            'message': {
              'content': 'Вот ваше изображение готово',
              'role': 'assistant',
            },
            'finish_reason': 'stop',
          }
        ]
      });
      return http.Response.bytes(utf8.encode(responseBody), 200);
    });

    final dataSource = ChatApiDataSource(clientFactory: clientFactory);
    final request = ChatRequest(
      model: 'GigaChat',
      messages: [
        ChatMessage(
          role: ChatRole.user,
          type: ChatMessageType.text,
          content: 'Нарисуй розового кота',
        ),
      ],
    );
    final result = await dataSource.sendMessage(request);

    expect(result.messages.isNotEmpty, true);
    expect(result.messages[0].content, 'Вот ваше изображение готово');
    expect(result.finishReason, 'stop');
  });

  test('getAvailableModels returns model ids', () async {
    final clientFactory = () async => MockClient((request) async {
      if (request.url.path == '/api/v2/oauth') {
        return http.Response(
          jsonEncode({
            'access_token': 'test-token',
            'expires_at': DateTime.now().millisecondsSinceEpoch + 10000,
          }),
          200,
        );
      }

      expect(request.method, 'GET');
      expect(request.url.path, '/api/v1/models');
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

    final dataSource = ChatApiDataSource(clientFactory: clientFactory);
    final models = await dataSource.getAvailableModels();

    expect(models, ['GigaChat', 'GigaChat-Pro']);
  });

  test('validateFunction returns validation error messages', () async {
    final clientFactory = () async => MockClient((request) async {
      if (request.url.path == '/api/v2/oauth') {
        return http.Response(
          jsonEncode({
            'access_token': 'test-token',
            'expires_at': DateTime.now().millisecondsSinceEpoch + 10000,
          }),
          200,
        );
      }

      expect(request.method, 'POST');
      expect(request.url.path, '/api/v1/functions/validation');
      final responseBody = jsonEncode({
        'errors': [
          {'message': 'Неверная сигнатура функции'},
        ],
      });
      return http.Response.bytes(utf8.encode(responseBody), 200);
    });

    final dataSource = ChatApiDataSource(clientFactory: clientFactory);
    final errors = await dataSource.validateFunction({'name': 'test', 'parameters': {}});

    expect(errors, ['Неверная сигнатура функции']);
  });

  test('sendMessage throws when completions endpoint returns non-200', () async {
    final clientFactory = () async => MockClient((request) async {
      if (request.url.path == '/api/v2/oauth') {
        return http.Response(
          jsonEncode({
            'access_token': 'test-token',
            'expires_at': DateTime.now().millisecondsSinceEpoch + 10000,
          }),
          200,
        );
      }

      return http.Response('Internal server error', 500);
    });

    final dataSource = ChatApiDataSource(clientFactory: clientFactory);
    final request = ChatRequest(
      model: 'GigaChat',
      messages: [
        ChatMessage(
          role: ChatRole.user,
          type: ChatMessageType.text,
          content: 'Привет',
        ),
      ],
    );

    expect(
      dataSource.sendMessage(request),
      throwsA(
        isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed to get chat response'),
        ),
      ),
    );
  });
}
