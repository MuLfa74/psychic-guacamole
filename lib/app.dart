import 'package:flutter/material.dart';
import 'features/chat/presentation/pages/chat_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI ChatBot',
      theme: ThemeData.dark(useMaterial3: true),
      home: const ChatPage(), // <- первая страница (чат с ИИ)
    );
  }
}
