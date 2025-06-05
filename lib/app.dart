import 'package:flutter/material.dart';
import 'chat_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GigaChat App',
      home: const ChatPage(),
    );
  }
}
