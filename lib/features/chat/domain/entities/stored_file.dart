import '../enums/file_modality.dart';

class StoredFile {
  final String id;
  final String filename;
  final String mimeType;
  final String purpose;
  final String accessPolicy;
  final int bytes;
  final List<FileModality> modalities;
  final int? createdAt;

  StoredFile({
    required this.id,
    required this.filename,
    required this.mimeType,
    required this.purpose,
    required this.accessPolicy,
    required this.bytes,
    required this.modalities,
    this.createdAt,
  });

  factory StoredFile.fromJson(Map<String, dynamic> json) {
    return StoredFile(
      id: json['id'] as String,
      filename: json['filename'] as String,
      mimeType: json['mimeType'] as String? ?? json['mime_type'] as String? ?? 'application/octet-stream',
      purpose: json['purpose'] as String,
      accessPolicy: json['accessPolicy'] as String? ?? json['access_policy'] as String? ?? 'private',
      bytes: json['bytes'] as int? ?? 0,
      modalities: (json['modalities'] as List<dynamic>?)
              ?.map((m) => FileModality.fromJson(m.toString()))
              .toList() ??
          [],
      createdAt: json['createdAt'] as int? ?? json['created_at'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filename': filename,
      'mimeType': mimeType,
      'purpose': purpose,
      'accessPolicy': accessPolicy,
      'bytes': bytes,
      'modalities': modalities.map((m) => m.toJson()).toList(),
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}
