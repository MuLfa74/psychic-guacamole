import '../entities/chat_message.dart';
import '../entities/chat_request.dart';
import '../entities/chat_response.dart';
import '../enums/chat_message_type.dart';
import '../enums/chat_role.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  /// Отправить текстовое сообщение
  Future<ChatResponse> call(String message) {
    final request = ChatRequest(
      model: 'GigaChat',
      messages: [
        ChatMessage(
          role: ChatRole.user,
          type: ChatMessageType.text,
          content: message,
        ),
      ],
    );
    return repository.sendMessage(request);
  }

  /// Отправить структурированный запрос
  Future<ChatResponse> sendRequest(ChatRequest request) {
    return repository.sendMessage(request);
  }
}
