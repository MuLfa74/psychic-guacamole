import '../../domain/entities/chat_message.dart';
import '../../domain/enums/chat_message_type.dart';
import '../../domain/enums/chat_role.dart';

class ChatMessageModel extends ChatMessage {
  ChatMessageModel({
    required ChatRole role,
    required String content,
    ChatMessageType type = ChatMessageType.text,
    String? attachmentId,
    String? imageId,
    Map<String, dynamic>? metadata,
  }) : super(
    role: role,
    content: content,
    type: type,
    attachmentId: attachmentId,
    imageId: imageId,
    metadata: metadata,
  );

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      role: ChatRole.fromJson(json['role'] as String? ?? 'user'),
      content: json['content'] as String,
      type: ChatMessageType.fromJson(json['type'] as String? ?? 'text'),
      attachmentId: json['attachmentId'] as String? ?? json['attachment_id'] as String?,
      imageId: json['imageId'] as String? ?? json['image_id'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  factory ChatMessageModel.fromEntity(ChatMessage entity) {
    return ChatMessageModel(
      role: entity.role,
      content: entity.content,
      type: entity.type,
      attachmentId: entity.attachmentId,
      imageId: entity.imageId,
      metadata: entity.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role.toJson(),
      'content': content,
      'type': type.toJson(),
      if (attachmentId != null) 'attachmentId': attachmentId,
      if (imageId != null) 'imageId': imageId,
      if (metadata != null) 'metadata': metadata,
    };
  }

  ChatMessage toEntity() {
    return ChatMessage(
      role: role,
      content: content,
      type: type,
      attachmentId: attachmentId,
      imageId: imageId,
      metadata: metadata,
    );
  }
}
