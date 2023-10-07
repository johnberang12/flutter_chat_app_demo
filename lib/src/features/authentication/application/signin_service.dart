// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../exceptions/app_exception.dart';

class SigninService {
  SigninService({required this.ref});
  final Ref ref;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(AppException) verificationFailed,
    required void Function(String, int?) codeSent,
  }) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    await ref.read(authRepositoryProvider).verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationFailed: verificationFailed,
        codeSent: codeSent);
  }

  Future<void> verifyOtpCode(
      {required String verificationId, required String otpCode}) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    await ref
        .read(authRepositoryProvider)
        .verifyOtpCode(verificationId: verificationId, otpCode: otpCode);
  }

  Future<void> updateDisplayName(String displayName) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    await ref.read(authRepositoryProvider).updateDisplayName(displayName);
  }
}

final signinServiceProvider =
    Provider<SigninService>((ref) => SigninService(ref: ref));
