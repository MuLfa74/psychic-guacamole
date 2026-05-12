import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'dart:io';
import '../../domain/entities/chat_request.dart';
import '../../domain/entities/chat_response.dart';
import '../models/chat_response_model.dart';
import '../models/generated_image_model.dart';
import '../models/stored_file_model.dart';
import 'api_get_token.dart';
import 'api_get_models.dart';
import 'api_validate_func.dart';
import 'http_cert_client.dart';

typedef SecureClientFactory = Future<http.Client> Function();

class ChatApiDataSource {
  final TokenManager _tokenManager;
  final SecureClientFactory _clientFactory;
  late final ModelFetcher _modelFetcher;
  late final FunctionValidator _validator;

  ChatApiDataSource({
    TokenManager? tokenManager,
    ModelFetcher? modelFetcher,
    FunctionValidator? validator,
    SecureClientFactory? clientFactory,
  })  : _clientFactory = clientFactory ?? _createSecureClient,
        _tokenManager = tokenManager ?? TokenManager(clientFactory: clientFactory) {
    _modelFetcher =
        modelFetcher ?? ModelFetcher(_tokenManager, clientFactory: clientFactory);
    _validator =
        validator ?? FunctionValidator(_tokenManager, clientFactory: clientFactory);
  }

  static Future<http.Client> _createSecureClient() async =>
      IOClient(await createSecureClient());

  Future<List<String>> getAvailableModels() => _modelFetcher.getModels();

  Future<List<String>> validateFunction(Map<String, dynamic> json) =>
      _validator.validateFunction(json);

  /// Отправить ChatRequest в GigaChat API
  Future<ChatResponse> sendMessage(ChatRequest request) async {
    final client = await _clientFactory();
    final token = await _tokenManager.getAccessToken();

    final body = <String, dynamic>{
      'model': request.model,
      'messages': request.messages
          .map((m) => {
                'role': m.role.toJson(),
                'content': m.content,
              })
          .toList(),
      'temperature': request.temperature ?? 1.0,
      'top_p': request.topP ?? 0.9,
      'n': request.n ?? 1,
      'stream': request.stream ?? false,
    };

    if (request.functionCall != null) {
      body['function_call'] = request.functionCall!;
    }
    if (request.attachments != null && request.attachments!.isNotEmpty) {
      body['attachments'] = request.attachments!;
    }

    final response = await client.post(
      Uri.parse('https://gigachat.devices.sberbank.ru/api/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'RqUID': _tokenManager.generateRqUID(),
      },
      body: jsonEncode(body),
      encoding: utf8,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get chat response: ${response.body}');
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return ChatResponseModel.fromJson(json);
  }

  /// Загрузить файл в хранилище GigaChat
  Future<StoredFileModel> uploadFile(String filePath, {String purpose = 'general'}) async {
    final client = await _clientFactory();
    final token = await _tokenManager.getAccessToken();
    final url = Uri.parse('https://gigachat.devices.sberbank.ru/api/v1/files');
    final request = http.MultipartRequest('POST', url);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    request.fields['purpose'] = purpose;

    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception("Файл не найден по пути: $filePath");}
    final bytes = await file.readAsBytes();
    
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: filePath.split('/').last,
    ));

    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return StoredFileModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Ошибка загрузки: ${response.statusCode} ${response.body}');
    }
}
  /// Получить список всех файлов
  Future<List<StoredFileModel>> getFiles() async {
    final client = await _clientFactory();
    final token = await _tokenManager.getAccessToken();

    final response = await client.get(
      Uri.parse('https://gigachat.devices.sberbank.ru/api/v1/files'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get files list: ${response.body}');
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final data = json['data'] as List;
    return data.map((f) => StoredFileModel.fromJson(f as Map<String, dynamic>)).toList();
  }

  /// Получить информацию о конкретном файле
  Future<StoredFileModel> getFileInfo(String fileId) async {
    final client = await _clientFactory();
    final token = await _tokenManager.getAccessToken();

    final response = await client.get(
      Uri.parse('https://gigachat.devices.sberbank.ru/api/v1/files/$fileId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get file info: ${response.body}');
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return StoredFileModel.fromJson(json);
  }

  /// Скачать содержимое файла (изображение, документ и т.д.)
  Future<GeneratedImageModel> downloadFileContent(String fileId) async {
    final client = await _clientFactory();
    final token = await _tokenManager.getAccessToken();

    final response = await client.get(
      Uri.parse('https://gigachat.devices.sberbank.ru/api/v1/files/$fileId/content'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/jpg',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to download file: ${response.body}');
    }

    return GeneratedImageModel(
      id: fileId,
      content: response.bodyBytes,
      mimeType: response.headers['content-type'] ?? 'application/octet-stream',
      bytes: response.contentLength ?? response.bodyBytes.length,
    );
  }

  /// Удалить файл из хранилища
  Future<void> deleteFile(String fileId) async {
    final client = await _clientFactory();
    final token = await _tokenManager.getAccessToken();

    final response = await client.post(
      Uri.parse('https://gigachat.devices.sberbank.ru/api/v1/files/$fileId/delete'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete file: ${response.body}');
    }
  }

  /// Вспомогательный метод для извлечения imageId из <img src="...">
  static String? extractImageId(String content) {
    final regex = RegExp(r'<img\s+src="([^"]+)"');
    final match = regex.firstMatch(content);
    return match?.group(1);
  }
}
