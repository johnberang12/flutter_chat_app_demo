import 'dart:io';
import 'package:crypto/crypto.dart';

String computeMD5Hash(File file) {
  final bytes = file.readAsBytesSync();
  return md5.convert(bytes).toString();
}
