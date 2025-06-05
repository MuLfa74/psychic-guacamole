import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';


Future<File> getCertFile() async {
  final byteData = await rootBundle.load('assets/cert_ru.pem');
  final bytes = byteData.buffer.asUint8List();

  final tempDir = await getTemporaryDirectory();
  final certFile = File('${tempDir.path}/cert_ru.pem');
  return await certFile.writeAsBytes(bytes);
}
