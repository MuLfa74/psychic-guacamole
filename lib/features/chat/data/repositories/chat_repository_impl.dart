import '../../domain/entities/chat_request.dart';
import '../../domain/entities/chat_response.dart';
import '../../domain/entities/stored_file.dart';
import '../../domain/entities/generated_image.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/api_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatApiDataSource apiDataSource;

  ChatRepositoryImpl(this.apiDataSource);

  @override
  Future<ChatResponse> sendMessage(ChatRequest request) {
    return apiDataSource.sendMessage(request);
  }

  @override
  Future<GeneratedImage> downloadFile(String fileId) {
    return apiDataSource.downloadFileContent(fileId);
  }

  @override
  Future<StoredFile> uploadFile(String filePath, {String purpose = 'general'}) {
    return apiDataSource.uploadFile(filePath, purpose: purpose);
  }

  @override
  Future<List<StoredFile>> listFiles() {
    return apiDataSource.getFiles();
  }

  @override
  Future<StoredFile> getFileInfo(String fileId) {
    return apiDataSource.getFileInfo(fileId);
  }

  @override
  Future<void> deleteFile(String fileId) {
    return apiDataSource.deleteFile(fileId);
  }
}
