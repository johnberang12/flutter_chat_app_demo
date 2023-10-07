// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/authentication/application/signin_service.dart';
import 'package:flutter_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppRouterListenable extends ChangeNotifier {
  AppRouterListenable({required this.ref});
  final Ref ref;

  Future<void> verifyOtpCode(
          {required String verificationId, required String otpCode}) =>
      ref
          .read(signinServiceProvider)
          .verifyOtpCode(verificationId: verificationId, otpCode: otpCode)
          .then((value) => notifyListeners());

  Future<void> signOut() => ref
      .read(authRepositoryProvider)
      .signOut()
      .then((value) => notifyListeners());
}

final appRouterListenableProvider =
    Provider<AppRouterListenable>((ref) => AppRouterListenable(ref: ref));
