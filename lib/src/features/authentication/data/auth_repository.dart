// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/src/utils/handle_async_error.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../exceptions/app_exception.dart';
import '../../users/domain/app_user.dart';
part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository({required this.auth});
  final FirebaseAuth auth;

  User? get currentUser => auth.currentUser;

  Stream<User?> authStateChanges() => auth.authStateChanges();

  Future<void> verifyPhoneNumber(
          {required String phoneNumber,
          required void Function(AppException) verificationFailed,
          required void Function(String, int?) codeSent}) =>
      auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (_) {},
          verificationFailed: (exception) => verificationFailed(
              convertToAppException(
                  title: 'Phone number verification failed',
                  exception: exception)),
          codeSent: codeSent,
          codeAutoRetrievalTimeout: (_) {},
          timeout: const Duration(seconds: 120));

  Future<void> verifyOtpCode(
      {required String verificationId, required String otpCode}) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpCode);

    currentUser != null && currentUser!.isAnonymous
        ? await linkWithCredential('Signin failed', credential)
        : await signInWithCredential('Signin failed', credential);
  }

  Future<void> signInWithCredential(
      String errorTitle, AuthCredential credential) async {
    await handleAsyncError(
        title: errorTitle,
        operation: () => auth.signInWithCredential(credential));
  }

  Future<void> linkWithCredential(
      String errorTitle, AuthCredential credential) async {
    await handleAsyncError(
        title: errorTitle,
        operation: () => auth.currentUser?.linkWithCredential(credential));
  }

  Future<void> signOut() async {
    for (var i = 0; i < 4; i++) {
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    throw Exception('Logout failed');
    await handleAsyncError(
        title: 'Sign out failed', operation: () => auth.signOut());
    // throw Exception('Something went wrong...');
  }

  Future<void> deleteAccount() async {
    for (var i = 0; i < 4; i++) {
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    throw Exception('Something went wrong');
  }

  Future<void> updateDisplayName(String displayName) async {
    await handleAsyncError(
        title: 'Failed to Update Display Name',
        operation: () => auth.currentUser?.updateDisplayName(displayName));
  }
}

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final authRepositoryProvider = Provider<AuthRepository>(
    (ref) => AuthRepository(auth: ref.watch(firebaseAuthProvider)));
final currentUserProvider = StateProvider<User?>(
    (ref) => ref.watch(authRepositoryProvider).currentUser);
final authStateChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(authRepositoryProvider).authStateChanges());

@Riverpod(keepAlive: true)
UserID userId(UserIdRef ref) =>
    ref.watch(authRepositoryProvider).currentUser?.uid ?? 'defaultId';
