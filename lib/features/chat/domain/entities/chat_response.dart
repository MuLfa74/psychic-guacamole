import 'chat_message.dart';

class ChatResponse {
  final List<ChatMessage> messages;
  final String? functionStateId;
  final String? finishReason;
  final Map<String, dynamic> rawJson;

  ChatResponse({
    required this.messages,
    this.functionStateId,
    this.finishReason,
    required this.rawJson,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    final choices = json['choices'] as List;
    final choice = choices.first as Map<String, dynamic>;
    final message = choice['message'] as Map<String, dynamic>;

    final messages = [ChatMessage.fromJson(message)];

    return ChatResponse(
      messages: messages,
      functionStateId: json['function_state_id'] as String?,
      finishReason: choice['finish_reason'] as String?,
      rawJson: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messages': messages.map((m) => m.toJson()).toList(),
      if (functionStateId != null) 'functionStateId': functionStateId,
      if (finishReason != null) 'finishReason': finishReason,
    };
  }
}
