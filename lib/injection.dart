import 'package:get_it/get_it.dart';

import 'features/chat/data/datasources/get_cert.dart';
import 'features/chat/data/datasources/api_data_source.dart';
import 'features/chat/data/datasources/api_get_models.dart';
import 'features/chat/data/datasources/api_get_token.dart';
import 'features/chat/data/datasources/api_validate_func.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/send_message_usecase.dart';
import 'features/chat/domain/usecases/generate_image_usecase.dart';
import 'features/chat/domain/usecases/download_image_usecase.dart';
import 'features/chat/domain/usecases/upload_file_usecase.dart';
import 'features/chat/domain/usecases/list_files_usecase.dart';
import 'features/chat/domain/usecases/delete_file_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => TokenManager());

  // Data Sources
  await getCertFile();
  sl.registerLazySingleton(() => ModelFetcher(sl()));
  sl.registerLazySingleton(() => FunctionValidator(sl()));
  sl.registerLazySingleton(() => ChatApiDataSource());

  // Repository
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));

  // UseCases
  sl.registerLazySingleton<SendMessageUseCase>(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton<GenerateImageUseCase>(() => GenerateImageUseCase(sl()));
  sl.registerLazySingleton<DownloadImageUseCase>(() => DownloadImageUseCase(sl()));
  sl.registerLazySingleton<UploadFileUseCase>(() => UploadFileUseCase(sl()));
  sl.registerLazySingleton<ListFilesUseCase>(() => ListFilesUseCase(sl()));
  sl.registerLazySingleton<DeleteFileUseCase>(() => DeleteFileUseCase(sl()));
}
