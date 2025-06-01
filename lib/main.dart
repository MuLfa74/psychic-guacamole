import 'package:flutter/material.dart';
import 'injection.dart';
import 'app.dart'; // твой корневой виджет

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}
