import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_application_ai_chat/features/chat/domain/entities/chat_message.dart';
import 'package:flutter_application_ai_chat/features/chat/domain/repositories/chat_repository.dart';
import 'package:flutter_application_ai_chat/features/chat/domain/usecases/send_message_usecase.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late SendMessageUseCase useCase;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    useCase = SendMessageUseCase(mockRepository);
  });

  test('should return List<ChatMessage> from repository', () async {
    const message = 'Привет';
    final mockResponse = [
      ChatMessage(role: 'user', content: message),
      ChatMessage(role: 'assistant', content: 'Здравствуйте!'),
    ];

    when(mockRepository.sendMessage(message)).thenAnswer((_) async => mockResponse);

    final result = await useCase(message);

    expect(result, equals(mockResponse));
    verify(mockRepository.sendMessage(message)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
