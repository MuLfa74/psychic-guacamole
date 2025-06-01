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

  test('should return list of ChatMessages from repository', () async {
    // arrange
    const testInput = 'Привет';
    final expectedMessages = [
      ChatMessage(role: 'user', content: 'Привет'),
      ChatMessage(role: 'assistant', content: 'Привет! Я GigaChat.')
    ];

    when(mockRepository.sendMessage(testInput))
        .thenAnswer((_) async => expectedMessages);

    // act
    final result = await useCase(testInput);

    // assert
    expect(result, equals(expectedMessages));
    verify(mockRepository.sendMessage(testInput)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
