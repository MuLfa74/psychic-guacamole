import '../../domain/entities/chat_response.dart';
import 'chat_message_model.dart';

class ChatResponseModel extends ChatResponse {
  ChatResponseModel({
    required List<ChatMessageModel> messages,
    String? functionStateId,
    String? finishReason,
    required Map<String, dynamic> rawJson,
  }) : super(
    messages: messages,
    functionStateId: functionStateId,
    finishReason: finishReason,
    rawJson: rawJson,
  );

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    final choices = json['choices'] as List;
    final choice = choices.first as Map<String, dynamic>;
    final message = choice['message'] as Map<String, dynamic>;

    final messageModel = ChatMessageModel.fromJson(message);

    return ChatResponseModel(
      messages: [messageModel],
      functionStateId: json['function_state_id'] as String?,
      finishReason: choice['finish_reason'] as String?,
      rawJson: json,
    );
  }
}
