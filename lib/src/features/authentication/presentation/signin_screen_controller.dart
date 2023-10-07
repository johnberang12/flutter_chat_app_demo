import 'package:flutter_chat_app/src/exceptions/app_exception.dart';
import 'package:flutter_chat_app/src/features/app_router/app_router_listenable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../application/signin_service.dart';

class SigninScreenController extends StateNotifier<AsyncValue<void>> {
  SigninScreenController({required this.service, required this.listenable})
      : super(const AsyncData(null));
  final SigninService service;
  final AppRouterListenable listenable;

  Future<void> verifyPhoneNumber(
      {required String phoneNumber,
      required Function(AppException) verificationFailed,
      required Function(String, int?) codeSent}) async {
    state = const AsyncLoading();
    final newState = await AsyncValue.guard(() => service.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationFailed: verificationFailed,
        codeSent: codeSent));
    if (mounted) {
      state = newState;
    }
  }

  Future<void> verifyOtpCode(
      {required String verificationId, required String otpCode}) async {
    state = const AsyncLoading();
    final newState = await AsyncValue.guard(() => listenable.verifyOtpCode(
        verificationId: verificationId, otpCode: otpCode));
    if (mounted) {
      state = newState;
    }
  }
}

final signinScreenControllerProvider =
    StateNotifierProvider.autoDispose<SigninScreenController, AsyncValue<void>>(
        (ref) => SigninScreenController(
            service: ref.watch(signinServiceProvider),
            listenable: ref.watch(appRouterListenableProvider)));
