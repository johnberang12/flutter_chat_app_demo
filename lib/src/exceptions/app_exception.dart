// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';

class AppException implements Exception {
  AppException({
    required this.title,
    this.code,
    required this.message,
    required this.originalException,
  });
  final String title;
  final String? code;
  final String message;
  final dynamic originalException;

  @override
  String toString() {
    return 'AppException(title: $title, code: $code, message: $message, originalException: $originalException)';
  }
}

///Utility function to convert any Exception to AppException
AppException convertToAppException(
    {required String title, required dynamic exception}) {
  if (exception is FirebaseAuthException) {
    return AppException(
        title: title,
        message: exception.message ?? 'Authentication Error Occured',
        originalException: exception,
        code: exception.code);
  }

  if (exception is FirebaseException) {
    return AppException(
        title: title,
        code: exception.code,
        message: exception.message ?? 'Internal Erro Occured',
        originalException: exception);
  }

  ///You can add more converts here for different exceptions
  ///e.g.,
  ///

  ///Default case
  return AppException(
      title: title,
      message: 'An internal error occurred',
      originalException: exception);
}
