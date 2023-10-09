import 'package:flutter/material.dart';

class TypeWriterText extends StatefulWidget {
  final String text;
  final Duration duration;
  final TextStyle? style;
  final VoidCallback? onComplete;

  TypeWriterText(this.text, {this.style, this.duration = const Duration(milliseconds: 50), this.onComplete});

  @override
  _TypeWriterTextState createState() => _TypeWriterTextState();
}

class _TypeWriterTextState extends State<TypeWriterText> {
  String _displayedString = '';
  int _currentCharIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.duration, _displayNextCharacter);
  }

  void _displayNextCharacter() {
    if (_currentCharIndex < widget.text.length) {
      setState(() {
        _displayedString += widget.text[_currentCharIndex];
        _currentCharIndex++;
      });
      Future.delayed(widget.duration, _displayNextCharacter);
    } else {
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedString,
      style: widget.style ?? TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
    );
  }
}

class Bubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final VoidCallback? onComplete;

  Bubble({required this.text, required this.isUser, this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: isUser ? Colors.blue : Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TypeWriterText(text, style: TextStyle(color: Colors.white), onComplete: onComplete),
    );
  }
}
