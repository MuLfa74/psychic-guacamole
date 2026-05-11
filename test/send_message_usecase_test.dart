import 'package:flutter_application_ai_chat/features/chat/domain/entities/chat_request.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_application_ai_chat/features/chat/domain/entities/chat_message.dart';
import 'package:flutter_application_ai_chat/features/chat/domain/entities/chat_response.dart';
import 'package:flutter_application_ai_chat/features/chat/domain/enums/chat_role.dart';
import 'package:flutter_application_ai_chat/features/chat/domain/enums/chat_message_type.dart';
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

  test('should return ChatResponse from repository', () async {
    // arrange
    const testInput = 'Привет';
    final expectedResponse = ChatResponse(
      messages: [
        ChatMessage(
          role: ChatRole.assistant,
          type: ChatMessageType.text,
          content: 'Привет! Я GigaChat.',
        )
      ],
      rawJson: {},
    );
    final request = ChatRequest(
      messages: [
        ChatMessage(
          role: ChatRole.user,
          type: ChatMessageType.text,
          content: 'Привет! Ты кто?'
        )
      ],
      model: 'GigaChat',
    );

    final result = await useCase(testInput);

    // Мокируем с использованием argThat для проверки типа
    when(mockRepository.sendMessage(
       request as ChatRequest,
    )).thenAnswer((_) async => expectedResponse);

    // assert
    expect(result.messages.length, 1);
    expect(result.messages[0].content, 'Привет! Я GigaChat.');
    expect(result.messages[0].role, ChatRole.assistant);
  });
}
