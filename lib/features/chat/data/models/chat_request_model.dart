import '../../domain/entities/chat_request.dart';
import 'chat_message_model.dart';

class ChatRequestModel extends ChatRequest {
  ChatRequestModel({
    required List<ChatMessageModel> messages,
    required String model,
    String? systemPrompt,
    String? functionCall,
    List<String>? attachments,
    double? temperature,
    double? topP,
    bool? stream,
    int? n,
  }) : super(
    messages: messages,
    model: model,
    systemPrompt: systemPrompt,
    functionCall: functionCall,
    attachments: attachments,
    temperature: temperature,
    topP: topP,
    stream: stream,
    n: n,
  );

  factory ChatRequestModel.fromEntity(ChatRequest entity) {
    return ChatRequestModel(
      messages: entity.messages.map((m) => ChatMessageModel.fromEntity(m)).toList(),
      model: entity.model,
      systemPrompt: entity.systemPrompt,
      functionCall: entity.functionCall,
      attachments: entity.attachments,
      temperature: entity.temperature,
      topP: entity.topP,
      stream: entity.stream,
      n: entity.n,
    );
  }

  Map<String, dynamic> toApiJson() {
    return {
      'model': model,
      'messages': messages.map((m) => {
        'role': m.role.toJson(),
        'content': m.content,
      }).toList(),
      if (systemPrompt != null) 'system_prompt': systemPrompt,
      if (functionCall != null) 'function_call': functionCall,
      if (attachments != null) 'attachments': attachments,
      if (temperature != null) 'temperature': temperature,
      if (topP != null) 'top_p': topP,
      if (stream != null) 'stream': stream,
      if (n != null) 'n': n,
    };
  }
}
