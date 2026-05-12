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

  test('Обычное сообщение к модели',
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

      _printInfo('Request: ${request.messages[0].content}');
      _printInfo('Model: ${request.model}');
      _printInfo('Sending request...');

      final startTime = DateTime.now();
      final result = await dataSource.sendMessage(request);
      final duration = DateTime.now().difference(startTime);

      _printSuccess('Response received in ${duration.inSeconds}s');
      _printInfo('Messages count: ${result.messages.length}');
      _printInfo(
          'Response content: ${result.messages[0].content.substring(0, min(100, result.messages[0].content.length))}...');


      expect(result.messages, isNotEmpty);
      expect(result.messages[0].content, isNotEmpty);
    },
    skip: !runIntegration,
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test('Генерация изображения',
    () async {
      final dataSource = ChatApiDataSource();
      final request = ChatRequest(
        model: 'GigaChat',
        functionCall: 'auto',
        messages: [
          ChatMessage(
            role: ChatRole.user,
            type: ChatMessageType.text,
            content:
                'Пожалуйста, создай изображение красивого заката над озером в стиле акварели.',
          ),
        ],
      );

      _printInfo('Request: ${request.messages[0].content}');
      _printInfo('Model: ${request.model}');
      _printInfo('Sending image request...');

      final startTime = DateTime.now();
      final result = await dataSource.sendMessage(request);
      final duration = DateTime.now().difference(startTime);

      _printSuccess('Response received in ${duration.inSeconds}s');
      _printInfo('Messages count: ${result.messages.length}');

      final message = result.messages[0];
      final preview = message.content.isNotEmpty
          ? message.content.substring(0, min(100, message.content.length))
          : '<empty>';

      _printInfo('Response content: $preview');
      _printInfo('Message type: ${message.type.toJson()}');
      _printInfo('Image ID: ${message.imageId ?? 'none'}');

      final imageId = message.imageId ?? ChatApiDataSource.extractImageId(message.content);
      expect(result.messages, isNotEmpty);
      expect(message.content, isNotEmpty);
      expect(imageId, isNotNull,
          reason: 'Ожидалось, что ответ содержит imageId или ссылку на изображение');

      if (imageId != null) {
        _printInfo('Downloading generated image: $imageId');
        final image = await dataSource.downloadFileContent(imageId);
        File('/storage/emulated/0/Download/$imageId.jpg').writeAsBytes(image.content!);
        _printSuccess('Downloaded image content: ${image.bytes} bytes');
        expect(image.bytes, greaterThan(0));
        expect(image.content, isNotNull);
      }
    },
    skip: !runIntegration,
    timeout: const Timeout(Duration(minutes: 3)),
  );

  test('Чтение файла',
    () async {
      final filePath = '/storage/emulated/0/Download/test.txt';

      final dataSource = ChatApiDataSource();
      final uploadedFile = await dataSource.uploadFile(filePath);
      final request = ChatRequest(
        model: 'GigaChat',
        functionCall: 'auto',
        messages: [
          ChatMessage(
            role: ChatRole.user,
            type: ChatMessageType.text,
            content:
                'Пожалуйста, прочитай дословно, что находиться в файле.',
            attachmentId: uploadedFile.id,
          ),
        ],
        attachments: [uploadedFile.id],
      );

      _printInfo('Request: ${request.messages[0].content}');
      _printInfo('Model: ${request.model}');
      _printInfo('Sending file...');

      final startTime = DateTime.now();
      final result = await dataSource.sendMessage(request);
      final duration = DateTime.now().difference(startTime);

      _printSuccess('Response received in ${duration.inSeconds}s');
      _printInfo('Messages count: ${result.messages.length}');

      final message = result.messages[0];
      final preview = message.content.isNotEmpty
          ? message.content.substring(0, min(100, message.content.length))
          : '<empty>';

      _printInfo('Response content: $preview');
      _printInfo('Message type: ${message.type.toJson()}');

      expect(result.messages, isNotEmpty);
      expect(message.content, isNotEmpty);
      },
    skip: !runIntegration,
    timeout: const Timeout(Duration(minutes: 3)),
  );
}

void _printSection(String title) {
  print('\n' + '=' * 70);
  print('  $title');
  print('=' * 70);
}

void _printHeader(String message) {
  print('\n╔═══════════════════════════════════════════════════════════════════╗');
  print('║  $message');
  print('╚═══════════════════════════════════════════════════════════════════╝');
}

void _printSuccess(String message) {
  print('✅ $message');
}

void _printInfo(String message) {
  print('ℹ️  $message');
}

void _printWarning(String message) {
  print('⚠️  $message');
}

void _printError(String message) {
  print('❌ $message');
}

int min(int a, int b) => a < b ? a : b;