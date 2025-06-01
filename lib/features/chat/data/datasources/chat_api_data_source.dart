import 'package:dio/dio.dart';
import 'auth_data_source.dart';

abstract class ChatApiDataSource {
  Future<String> sendMessage(String message);
}

class ChatApiDataSourceImpl implements ChatApiDataSource {
  final Dio dio;
  final AuthDataSource authDataSource;

  ChatApiDataSourceImpl({required this.dio, required this.authDataSource});

  @override
  Future<String> sendMessage(String message) async {
    final token = await authDataSource.getAccessToken();

    final response = await dio.post(
      'https://gigachat.devices.sberbank.ru/api/v1/chat/completions',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        "model": "GigaChat",
        "messages": [
          {"role": "user", "content": message}
        ],
      },
    );

    return response.data['choices'][0]['message']['content'];
  }
}
