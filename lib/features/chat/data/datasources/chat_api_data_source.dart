import 'package:dio/dio.dart';
import '../models/chat_message_model.dart';

abstract class ChatApiDataSource {
  Future<List<ChatMessageModel>> sendMessage(String message);
}

class ChatApiDataSourceImpl implements ChatApiDataSource {
  final Dio dio;
  final String apiKey;

  ChatApiDataSourceImpl({required this.dio, required this.apiKey});

  @override
  Future<List<ChatMessageModel>> sendMessage(String message) async {
    final response = await dio.post(
      'https://gigachat.devices.sberbank.ru/api/v1/chat/completions',
      data: {
        "model": "GigaChat",
        "messages": [
          {"role": "user", "content": message}
        ],
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
      ),
    );

    final choices = response.data['choices'] as List;

    return choices.map((choice) {
      final msg = choice['message'];
      return ChatMessageModel.fromJson(msg);
    }).toList();
  }
}
