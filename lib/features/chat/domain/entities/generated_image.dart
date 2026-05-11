import 'dart:typed_data';

class GeneratedImage {
  final String id;
  final String? filename;
  final Uint8List? content;
  final String? mimeType;
  final int? bytes;
  final DateTime? createdAt;

  GeneratedImage({
    required this.id,
    this.filename,
    this.content,
    this.mimeType = 'image/jpeg',
    this.bytes,
    this.createdAt,
  });

  factory GeneratedImage.fromJson(Map<String, dynamic> json) {
    return GeneratedImage(
      id: json['id'] as String,
      filename: json['filename'] as String?,
      content: json['content'] as Uint8List?,
      mimeType: json['mimeType'] as String? ?? 'image/jpeg',
      bytes: json['bytes'] as int?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (filename != null) 'filename': filename,
      if (mimeType != null) 'mimeType': mimeType,
      if (bytes != null) 'bytes': bytes,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }
}
