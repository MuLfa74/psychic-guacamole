import '../entities/chat_message.dart';
import '../entities/chat_request.dart';
import '../entities/chat_response.dart';
import '../enums/chat_message_type.dart';
import '../enums/chat_role.dart';
import '../repositories/chat_repository.dart';

class GenerateImageUseCase {
  final ChatRepository repository;

  GenerateImageUseCase(this.repository);

  Future<ChatResponse> call(String prompt) async {
    final request = ChatRequest(
      model: 'GigaChat',
      functionCall: 'auto',
      messages: [
        ChatMessage(
          role: ChatRole.user,
          type: ChatMessageType.text,
          content: prompt,
        ),
      ],
    );
    return repository.sendMessage(request);
  }
}

