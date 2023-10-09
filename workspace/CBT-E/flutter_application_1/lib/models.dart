class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class Content {
  final String text;
  final List<String>? choices;
  final bool auto;
  bool showChoices;

  Content({
    required this.text,
    this.choices,
    this.auto = true,
    this.showChoices = false,
  });
}
