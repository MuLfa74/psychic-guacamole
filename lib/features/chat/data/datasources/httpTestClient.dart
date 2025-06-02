import 'dart:io';

import 'package:http/io_client.dart';

HttpClient getHttpClientIgnoreCertificate() {
  final client = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  return client;
}

final httpClient = IOClient(getHttpClientIgnoreCertificate());
