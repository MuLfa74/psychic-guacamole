import 'package:get_it/get_it.dart';

import 'features/chat/data/datasources/api_data_source.dart';
import 'features/chat/data/datasources/api_get_models.dart';
import 'features/chat/data/datasources/api_get_token.dart';
import 'features/chat/data/datasources/api_validate_func.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => TokenManager());

  // Data Sources
  sl.registerLazySingleton(() => ModelFetcher(sl()));
  sl.registerLazySingleton(() => FunctionValidator(sl()));
  sl.registerLazySingleton(() => ChatApiDataSource());

  // Тут можно добавить репозитории, use cases и т.д.
}
