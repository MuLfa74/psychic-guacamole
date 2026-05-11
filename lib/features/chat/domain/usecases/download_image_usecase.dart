import '../entities/generated_image.dart';
import '../repositories/chat_repository.dart';

class DownloadImageUseCase {
  final ChatRepository repository;

  DownloadImageUseCase(this.repository);

  Future<GeneratedImage> call(String imageId) {
    return repository.downloadFile(imageId);
  }
}
