import 'chat_message.dart';

class ChatRequest {
  final List<ChatMessage> messages;
  final String model;
  final String? systemPrompt;
  final String? functionCall;
  final List<String>? attachments;
  final double? temperature;
  final double? topP;
  final bool? stream;
  final int? n;

  ChatRequest({
    required this.messages,
    required this.model,
    this.systemPrompt,
    this.functionCall,
    this.attachments,
    this.temperature,
    this.topP,
    this.stream,
    this.n,
  });

  factory ChatRequest.fromJson(Map<String, dynamic> json) {
    return ChatRequest(
      messages: (json['messages'] as List).map((m) => ChatMessage.fromJson(m as Map<String, dynamic>)).toList(),
      model: json['model'] as String,
      systemPrompt: json['systemPrompt'] as String?,
      functionCall: json['functionCall'] as String?,
      attachments: (json['attachments'] as List?)?.cast<String>(),
      temperature: json['temperature'] as double?,
      topP: json['topP'] as double?,
      stream: json['stream'] as bool?,
      n: json['n'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messages': messages.map((m) => m.toJson()).toList(),
      'model': model,
      if (systemPrompt != null) 'systemPrompt': systemPrompt,
      if (functionCall != null) 'functionCall': functionCall,
      if (attachments != null) 'attachments': attachments,
      if (temperature != null) 'temperature': temperature,
      if (topP != null) 'topP': topP,
      if (stream != null) 'stream': stream,
      if (n != null) 'n': n,
    };
  }
}
