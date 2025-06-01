import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_api_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatApiDataSource apiDataSource;

  ChatRepositoryImpl(this.apiDataSource);

  @override
  Future<List<ChatMessage>> sendMessage(String message) async {
    return await apiDataSource.sendMessage(message);
  }
}
