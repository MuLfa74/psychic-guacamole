import '../entities/stored_file.dart';
import '../repositories/chat_repository.dart';

class UploadFileUseCase {
  final ChatRepository repository;

  UploadFileUseCase(this.repository);

  Future<StoredFile> call(String filePath, {String purpose = 'general'}) {
    return repository.uploadFile(filePath, purpose: purpose);
  }
}
