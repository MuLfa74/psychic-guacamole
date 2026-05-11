import '../repositories/chat_repository.dart';

class DeleteFileUseCase {
  final ChatRepository repository;

  DeleteFileUseCase(this.repository);

  Future<void> call(String fileId) {
    return repository.deleteFile(fileId);
  }
}
