import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'features/chat/data/datasources/chat_api_data_source.dart';
import 'features/chat/data/datasources/auth_data_source.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await dotenv.load(fileName: '.env');

  final dio = Dio();
  sl.registerLazySingleton(() => dio);

  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSource(
      dio: dio,
      authKey: dotenv.env['AUTHORIZATION_KEY']!,
    ),
  );

  sl.registerLazySingleton<ChatApiDataSource>(
    () => ChatApiDataSourceImpl(
      dio: dio,
      authDataSource: sl<AuthDataSource>(),
    ),
  );

  // + репозиторий, useCase и т.д.
}
