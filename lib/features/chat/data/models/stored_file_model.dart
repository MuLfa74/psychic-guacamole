import '../../domain/entities/stored_file.dart';
import '../../domain/enums/file_modality.dart';

class StoredFileModel extends StoredFile {
  StoredFileModel({
    required String id,
    required String filename,
    required String mimeType,
    required String purpose,
    required String accessPolicy,
    required int bytes,
    required List<FileModality> modalities,
    int? createdAt,
  }) : super(
    id: id,
    filename: filename,
    mimeType: mimeType,
    purpose: purpose,
    accessPolicy: accessPolicy,
    bytes: bytes,
    modalities: modalities,
    createdAt: createdAt,
  );

  factory StoredFileModel.fromJson(Map<String, dynamic> json) {
    return StoredFileModel(
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
}
