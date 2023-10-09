import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatbotPage(),
    );
  }
}

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
  String displayText = "";

  Content({
    required this.text,
    this.choices,
    this.auto = true,
    this.showChoices = false,
  });
}

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  int _currentContentIndex = 0;
  List<ChatMessage> messages = [];

  final List<Content> contents = [
    Content(text: 'Hi，你好呀，我是小E', auto: true),
    Content(text: '首先，我要恭喜你！祝贺你勇敢地迈出了对抗暴食和成为更好的自己的第一步', auto: true),
    Content(text: '在这条路上，你从来不是一个人。我们E-Heart团队将使用最早由英国牛津大学Christopher G. Fairburn教授提出、发展，现已得到多项临床试验验证的，目前对于成人饮食障碍最有效的、最权威的治疗方法——CBT-E（饮食障碍认知行为疗法）全程辅助您的恢复', choices: ['好的'], auto: false),
    Content(text: '这两种暴食唯一的区别在于您的感受，如果您在摄入大量食物时有失控感，感受到强烈的内心压力和焦虑并且伴随着负罪感和自责，那么您属于第一类：主观暴食', auto: true),
    Content(text: '如果您在大量进食时是机械性的，那么您属于第二类：客观暴食', auto: true),
    Content(text: '小E相信聪明的你已经掌握并且可以判断自己暴食的类型了，来试试吧', auto: true),
    Content(text: '你是属于哪一种暴食的类型呢？', choices: ['主观暴食', '客观暴食'], auto: false),
    Content(text: '恭喜，已经完成第二步啦！', auto: true)

  ];

  @override
  void initState() {
    super.initState();
    _displayNextContent();
  }

  void _displayNextContent() {
  if (_currentContentIndex < contents.length) {
    Content currentContent = contents[_currentContentIndex];

    int charIndex = 0;
    Timer.periodic(Duration(milliseconds: 50), (timer) { // <-- change the duration for faster/slower effect
      if (charIndex < currentContent.text.length) {
        setState(() {
          currentContent.displayText += currentContent.text[charIndex];
        });
        charIndex++;
      } else {
        timer.cancel();
        if (currentContent.auto) {
          Future.delayed(Duration(seconds: 1), () {
            _currentContentIndex++;
            _displayNextContent();
          });
        } else if (currentContent.choices != null) {
          Future.delayed(Duration(seconds: 1), () {
            setState(() {}); // To trigger a rebuild for showing choices
          });
        }
      }
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot App'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      message.isUser ? Icon(Icons.person) : Icon(Icons.android),
                      SizedBox(width: 10),
                      Expanded(child: Text(message.text, style: TextStyle(fontSize: 20, color: message.isUser ? Colors.blue : Colors.black))),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_currentContentIndex < contents.length && contents[_currentContentIndex].showChoices && contents[_currentContentIndex].choices != null)
            ...contents[_currentContentIndex].choices!.map((choice) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    messages.add(ChatMessage(text: choice, isUser: true));
                    contents[_currentContentIndex].showChoices = false;
                  });
                  _currentContentIndex++;
                  _displayNextContent();
                },
                child: Text(choice),
              );
            }).toList(),
        ],
      ),
    );
  }
}
