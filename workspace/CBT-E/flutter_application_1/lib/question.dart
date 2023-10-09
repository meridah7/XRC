class ChatMessage {
  final String text;
  final bool isUser; // 如果是用户发送的消息，则为true，否则为false

  ChatMessage({required this.text, required this.isUser});
}
