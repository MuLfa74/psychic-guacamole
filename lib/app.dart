import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
