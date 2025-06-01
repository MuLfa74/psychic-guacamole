import '../entities/chat_message.dart';

abstract class ChatRepository {
  Future<List<ChatMessage>> sendMessage(String message);
}
