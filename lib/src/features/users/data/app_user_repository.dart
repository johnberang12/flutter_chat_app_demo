// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_chat_app/src/services/firestore/db_path.dart';
import 'package:flutter_chat_app/src/services/firestore/firestore_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/app_user.dart';
part 'app_user_repository.g.dart';

class AppUserRepository {
  AppUserRepository({
    required FirestoreService service,
  }) : _service = service;
  final FirestoreService _service;

  Future<void> createAppUser(AppUser appUser) =>
      _service.setData(path: DBPath.user(appUser.uid), data: appUser.toMap());

  Future<AppUser?> getAppUser(UserID userId) => _service.getDocument(
      path: DBPath.user(userId), builder: (data) => AppUser.fromMap(data));

  Future<void> deleteUser(UserID userId) =>
      _service.deleteData(path: DBPath.user(userId));

  Stream<List<AppUser?>> watchUsers(UserID userId) => _service.collectionStream(
        path: DBPath.users(),
        builder: (data) => AppUser.fromMap(data),
        queryBuilder: (query) => query!.where('uid', isNotEqualTo: userId),
      );
}

final appUserRepositoryProvider = Provider<AppUserRepository>(
    (ref) => AppUserRepository(service: ref.watch(firestoreServiceProvider)));

@riverpod
FutureOr<AppUser?> appUserFuture(AppUserFutureRef ref, UserID userId) =>
    ref.watch(appUserRepositoryProvider).getAppUser(userId);
