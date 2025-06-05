import 'dart:io';
import 'get_cert.dart';

Future<HttpClient> createSecureClient() async {
  final certFile = await getCertFile();

  final context = SecurityContext();
  context.setTrustedCertificates(certFile.path);

  final client = HttpClient(context: context);
  return client;
}
