import '../entities/chat_request.dart';
import '../entities/chat_response.dart';
import '../entities/stored_file.dart';
import '../entities/generated_image.dart';

abstract class ChatRepository {
  /// Отправить сообщение в GigaChat
  Future<ChatResponse> sendMessage(ChatRequest request);

  /// Скачать файл из хранилища по идентификатору
  Future<GeneratedImage> downloadFile(String fileId);

  /// Загрузить файл в хранилище GigaChat
  Future<StoredFile> uploadFile(String filePath, {String purpose = 'general'});

  /// Получить список всех доступных файлов
  Future<List<StoredFile>> listFiles();

  /// Получить информацию о конкретном файле
  Future<StoredFile> getFileInfo(String fileId);

  /// Удалить файл из хранилища
  Future<void> deleteFile(String fileId);
}