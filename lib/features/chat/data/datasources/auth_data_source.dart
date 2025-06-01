import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

class AuthDataSource {
  final Dio dio;
  final String authKey;

  AuthDataSource({required this.dio, required this.authKey});

  Future<String> getAccessToken() async {
    final response = await dio.post(
      'https://ngw.devices.sberbank.ru:9443/api/v2/oauth',
      options: Options(
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'RqUID': const Uuid().v4(), // генерируем уникальный идентификатор
          'Authorization': 'Basic $authKey',
        },
      ),
      data: {'scope': 'GIGACHAT_API_PERS'},
    );

    return response.data['access_token'];
  }
}
