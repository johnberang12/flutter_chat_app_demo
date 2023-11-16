// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_chat_app/src/features/users/data/app_user_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/app_user.dart';

class AppUserService {
  AppUserService({required this.ref});
  final Ref ref;

  AppUserRepository _repository() => ref.read(appUserRepositoryProvider);

  Future<void> createAppUser(AppUser appUser) =>
      _repository().createAppUser(appUser);
  Future<void> deleteUser(UserID userId) => _repository().deleteUser(userId);

  Future<List<AppUser>> fetchInitialUsers({required int limit}) =>
      _repository().getAppUsers(
          queryBuilder: (query) =>
              query!.orderBy('name', descending: true).limit(limit));

  Future<List<AppUser>> fetchNextBatchUsers(
          {required int limit, required DocumentSnapshot documentSnapshot}) =>
      _repository().getAppUsers(
          queryBuilder: (query) => query!
              .orderBy('name', descending: true)
              .startAfterDocument(documentSnapshot)
              .limit(limit));
}

final appUserServiceProvider =
    Provider<AppUserService>((ref) => AppUserService(ref: ref));

final appUsersStreamProvider = StreamProvider.autoDispose<List<AppUser>>((ref) {
  final userId =
      ref.watch(authRepositoryProvider).currentUser?.uid ?? 'defaultId';
  return ref.watch(appUserRepositoryProvider).watchUsers(userId);
});
