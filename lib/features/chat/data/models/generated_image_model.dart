import 'dart:typed_data';
import '../../domain/entities/generated_image.dart';

class GeneratedImageModel extends GeneratedImage {
  GeneratedImageModel({
    required String id,
    String? filename,
    Uint8List? content,
    String? mimeType,
    int? bytes,
    DateTime? createdAt,
  }) : super(
    id: id,
    filename: filename,
    content: content,
    mimeType: mimeType,
    bytes: bytes,
    createdAt: createdAt,
  );

  factory GeneratedImageModel.fromJson(Map<String, dynamic> json) {
    return GeneratedImageModel(
      id: json['id'] as String,
      filename: json['filename'] as String?,
      content: json['content'] as Uint8List?,
      mimeType: json['mimeType'] as String? ?? 'image/jpeg',
      bytes: json['bytes'] as int?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
    );
  }
}
