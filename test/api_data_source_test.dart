import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_application_ai_chat/features/chat/data/datasources/api_data_source.dart';

void main() {
  setUpAll(() async {
  });

  test('sendMessage returns a valid response from real API', () async {
    final dataSource = ChatApiDataSource();

    final response = await dataSource.sendMessage("Привет! Кто ты?");
    print('Ответ: $response');

    expect(response.isNotEmpty, true); // проверяем, что ответ не пустой
  });
}
