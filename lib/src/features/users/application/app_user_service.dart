// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_chat_app/src/features/users/data/app_user_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/app_user.dart';

class AppUserService {
  AppUserService({required this.ref});
  final Ref ref;

  Future<void> createAppUser(AppUser appUser) =>
      ref.read(appUserRepositoryProvider).createAppUser(appUser);
  Future<void> deleteUser(UserID userId) =>
      ref.read(appUserRepositoryProvider).deleteUser(userId);
}

final appUserServiceProvider =
    Provider<AppUserService>((ref) => AppUserService(ref: ref));
final appUsersStreamProvider =
    StreamProvider.autoDispose<List<AppUser?>>((ref) {
  final userId =
      ref.watch(authRepositoryProvider).currentUser?.uid ?? 'defaultId';
  return ref.watch(appUserRepositoryProvider).watchUsers(userId);
});
