import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Chat Feature
import 'features/chat/data/datasources/chat_api_data_source.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/send_message_usecase.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await dotenv.load(fileName: ".env");
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<ChatApiDataSource>(
    () => ChatApiDataSourceImpl(
      dio: sl<Dio>(),
      apiKey: dotenv.env['GIGACHAT_APIKEY']!,
    ),
  );

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl<ChatApiDataSource>()),
  );

  sl.registerLazySingleton<SendMessageUseCase>(
    () => SendMessageUseCase(sl<ChatRepository>()),
  );
}
