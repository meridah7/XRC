import 'package:flutter/material.dart';
import 'models.dart';
import 'widgets.dart';

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
    Content(text: '你是属于哪一种暴食的类型呢？', choices: ['主观暴食', '客观暴食'], auto: false),
    Content(text: '如果您在大量进食时是机械性的，那么您属于第二类：客观暴食', auto: true),
    Content(text: '小E相信聪明的你已经掌握并且可以判断自己暴食的类型了，来试试吧', auto: true),
    Content(text: '小E相信聪明的你已经掌握并且可以判断自己暴食的类型了，来试试吧', auto: true),
  ];

  @override
  void initState() {
    super.initState();
    _displayNextContent();
  }

  void _displayNextContent() {
    if (_currentContentIndex < contents.length) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          messages.add(ChatMessage(text: contents[_currentContentIndex].text, isUser: false));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chatbot App')),
      body: Column(children: _buildBodyWidgets()),
    );
  }

  List<Widget> _buildBodyWidgets() {
    List<Widget> widgets = [];

    widgets.add(Expanded(child: _buildMessageList()));

    if (_currentContentIndex < contents.length &&
        contents[_currentContentIndex].showChoices &&
        contents[_currentContentIndex].choices != null) {
      widgets.add(_buildChoiceButtons());
    }

    return widgets;
  }

  ListView _buildMessageList() {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) => _buildMessageRow(messages[index]),
    );
  }

  Row _buildMessageRow(ChatMessage message) {
    return Row(
      mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!message.isUser) Icon(Icons.android, color: Colors.green),
        Flexible(child: Bubble(text: message.text, isUser: message.isUser, onComplete: _handleBubbleComplete)),
        if (message.isUser) Icon(Icons.person, color: Colors.blue),
      ],
    );
  }

  void _handleBubbleComplete() {
    if (contents[_currentContentIndex].auto) {
      _currentContentIndex++;
      _displayNextContent();
    } else if (!contents[_currentContentIndex].auto && contents[_currentContentIndex].choices != null) {
      setState(() {
        contents[_currentContentIndex].showChoices = true;
      });
    }
  }

  Widget _buildChoiceButtons() {
    return Row(
      children: contents[_currentContentIndex].choices!.map((choice) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton(
              onPressed: () => _handleChoiceButtonPressed(choice),
              child: Text(choice),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _handleChoiceButtonPressed(String choice) {
    setState(() {
      messages.add(ChatMessage(text: choice, isUser: true));
      contents[_currentContentIndex].showChoices = false;
    });
    _currentContentIndex++;
  }
}
