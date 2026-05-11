import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_ai_chat/features/chat/data/datasources/api_data_source.dart';
import 'package:flutter_application_ai_chat/features/chat/domain/entities/chat_message.dart';
import 'package:flutter_application_ai_chat/features/chat/domain/entities/chat_request.dart';
import 'package:flutter_application_ai_chat/features/chat/domain/enums/chat_message_type.dart';
import 'package:flutter_application_ai_chat/features/chat/domain/enums/chat_role.dart';
import 'package:integration_test/integration_test.dart';


void main() {
  const envFlag = 'RUN_INTEGRATION_TESTS';
  final runIntegration = Platform.environment[envFlag] == '1';
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();


  setUpAll(() async {
    await dotenv.load();
  });

  test(
    'integration: sendMessage real API returns assistant reply',
    () async {
      final dataSource = ChatApiDataSource();
      final request = ChatRequest(
        model: 'GigaChat',
        messages: [
          ChatMessage(
            role: ChatRole.user,
            type: ChatMessageType.text,
            content: 'Привет! Расскажи коротко, что ты умеешь.',
          ),
        ],
      );

      final result = await dataSource.sendMessage(request);

      expect(result.messages, isNotEmpty);
      expect(result.messages[0].content, isNotEmpty);
    },
    skip: !runIntegration,
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'integration: validateFunction real API returns no exception',
    () async {
      final validator = ChatApiDataSource().validateFunction;
      final functionJson = {
        'name': 'add_numbers',
        'description': 'Складывает два числа',
        'parameters': {
          'type': 'object',
          'properties': {
            'a': {'type': 'number'},
            'b': {'type': 'number'},
          },
          'required': ['a', 'b'],
        },
      };

      final errors = await validator(functionJson);
      expect(errors, isA<List<String>>());
    },
    skip: !runIntegration,
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
