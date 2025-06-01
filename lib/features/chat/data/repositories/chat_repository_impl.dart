import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_api_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatApiDataSource apiDataSource;

  ChatRepositoryImpl(this.apiDataSource);

  @override
  Future<List<ChatMessage>> sendMessage(String message) async {
    final response = await apiDataSource.sendMessage(message); // вернёт String

    return [
      ChatMessage(role: 'user', content: message),
      ChatMessage(role: 'assistant', content: response),
    ];
  }
}
