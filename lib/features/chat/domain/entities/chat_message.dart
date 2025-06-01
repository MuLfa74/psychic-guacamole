class ChatMessage {
  final String role; // 'user' или 'assistant'
  final String content;

  ChatMessage({
    required this.role,
    required this.content,
  });
}
