import '../entities/stored_file.dart';
import '../repositories/chat_repository.dart';

class ListFilesUseCase {
  final ChatRepository repository;

  ListFilesUseCase(this.repository);

  Future<List<StoredFile>> call() {
    return repository.listFiles();
  }
}
