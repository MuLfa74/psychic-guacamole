import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_application_ai_chat/features/chat/data/datasources/api_validate_func.dart';
import 'package:flutter_application_ai_chat/features/chat/data/datasources/api_get_token.dart';

void main() {

  test('returns error messages when validation endpoint returns errors', () async {
    final tokenClient = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'access_token': 'test-token',
          'expires_at': DateTime.now().millisecondsSinceEpoch + 10000,
        }),
        200,
      );
    });

    final validatorClient = MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.url.path, '/api/v1/functions/validation');
      expect(request.headers['Authorization'], 'Bearer test-token');
      final responseBody = jsonEncode({
        'errors': [
          {'message': 'Field name is required'},
          {'message': 'Invalid return type'},
        ],
      });
      return http.Response(responseBody, 200);
    });

    final tokenManager = TokenManager(clientFactory: () async => tokenClient);
    final validator = FunctionValidator(
      tokenManager,
      clientFactory: () async => validatorClient,
    );

    final errors = await validator.validateFunction({
      'name': 'some_func',
      'parameters': {},
    });

    expect(errors, ['Field name is required', 'Invalid return type']);
  });

  test('throws when validation endpoint returns non-200', () async {
    final tokenClient = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'access_token': 'test-token',
          'expires_at': DateTime.now().millisecondsSinceEpoch + 10000,
        }),
        200,
      );
    });

    final validatorClient = MockClient((request) async {
      return http.Response('Invalid definition', 400);
    });

    final tokenManager = TokenManager(clientFactory: () async => tokenClient);
    final validator = FunctionValidator(
      tokenManager,
      clientFactory: () async => validatorClient,
    );

    expect(
      validator.validateFunction({'name': 'invalid'}),
      throwsA(
        isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed to validate function'),
        ),
      ),
    );
  });
}
