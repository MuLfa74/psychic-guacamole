import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_application_ai_chat/features/chat/data/datasources/api_data_source.dart';
import 'package:flutter_application_ai_chat/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:flutter_application_ai_chat/features/chat/domain/entities/chat_message.dart';

class MockChatApiDataSource extends Mock implements ChatApiDataSource {}

void main() {
  late ChatRepositoryImpl repository;
  late MockChatApiDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockChatApiDataSource();
    repository = ChatRepositoryImpl(mockDataSource);
  });

  test('should return List<ChatMessage> from API response', () async {
    // arrange
    const userMessage = 'Привет';
    const assistantResponse = 'Здравствуйте! Чем могу помочь?';

    when(mockDataSource.sendMessage(userMessage))
        .thenAnswer((_) async => assistantResponse);

    // act
    final result = await repository.sendMessage(userMessage);

    // assert
    expect(result.length, 2);
    expect(result[0], isA<ChatMessage>());
    expect(result[0].role, 'user');
    expect(result[0].content, userMessage);

    expect(result[1].role, 'assistant');
    expect(result[1].content, assistantResponse);
  });
}
