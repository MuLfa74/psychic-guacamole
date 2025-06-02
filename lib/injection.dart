import 'package:get_it/get_it.dart';

import 'features/chat/data/datasources/api_data_source.dart';
import 'features/chat/data/datasources/api_get_models.dart';
import 'features/chat/data/datasources/api_get_token.dart';
import 'features/chat/data/datasources/api_validate_func.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/send_message_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => TokenManager());

  // Data Sources
  sl.registerLazySingleton(() => ModelFetcher(sl()));
  sl.registerLazySingleton(() => FunctionValidator(sl()));
  sl.registerLazySingleton(() => ChatApiDataSource());

  // Repository
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));

  // UseCase
  sl.registerLazySingleton<SendMessageUseCase>(() => SendMessageUseCase(sl()));
}
