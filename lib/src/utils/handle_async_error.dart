import 'package:flutter/foundation.dart';
import 'package:flutter_chat_app/src/exceptions/app_exception.dart';

Future<T?> handleAsyncError<T>(
    {required String title, required Future<T>? Function() operation}) async {
  try {
    return await operation();
  } catch (e) {
    debugPrint("error from: $title, error: $e ");
    throw convertToAppException(title: title, exception: e);
  }
}
