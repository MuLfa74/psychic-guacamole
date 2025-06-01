import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  ChatMessageModel({
    required String text,
    required bool isUser,
    required DateTime timestamp,
  }) : super(text: text, isUser: isUser, timestamp: timestamp);

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      text: json['content'],
      isUser: json['role'] == 'user',
      timestamp: DateTime.now(), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': isUser ? 'user' : 'assistant',
      'content': text,
    };
  }
}
