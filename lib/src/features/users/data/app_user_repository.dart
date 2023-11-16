// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> updateAppUser(UserID userId, Map<String, dynamic> data) =>
      _service.updateDoc(path: DBPath.user(userId), data: data);
  Future<void> deleteUser(UserID userId) =>
      _service.deleteData(path: DBPath.user(userId));

  Future<AppUser?> getAppUser(UserID userId) => _service.getDocument(
      path: DBPath.user(userId), builder: (data) => AppUser.fromMap(data));

  Stream<AppUser?> watchAppUser(UserID userId) => _service.documentStream(
      path: DBPath.user(userId), builder: AppUser.fromMap);
  Future<List<AppUser>> getAppUsers(
          {Query Function(Query? query)? queryBuilder}) =>
      _service.fetchCollection(
          path: DBPath.users(),

          ///assertion operator can be safely used here
          builder: (data) => AppUser.fromMap(data)!,
          queryBuilder: queryBuilder);

  Query _paginatedQuery(
      Query query, int pageSize, DocumentSnapshot? docSnapshot) {
    final initialQuery =
        query.orderBy('name', descending: true).limit(pageSize);

    return docSnapshot != null
        ? initialQuery.startAfterDocument(docSnapshot)
        : initialQuery;
  }

  Future<(List<AppUser>, DocumentSnapshot?)> fetchPaginatedUsers(
      {required int pageSize, DocumentSnapshot? docSnapshot}) async {
    final result = await _service.fetchPaginatedData(
        path: DBPath.users(),
        builder: (data) => AppUser.fromMap(data)!,
        queryBuilder: (query) =>
            _paginatedQuery(query!, pageSize, docSnapshot));

    return (result.$1, result.$2);
  }

  Stream<List<AppUser>> watchUsers(UserID userId) => _service.collectionStream(
        path: DBPath.users(),
        builder: (data) => AppUser.fromMap(data)!,
        queryBuilder: (query) => query!.where('uid', isNotEqualTo: userId),
      );

  Future<List<AppUser>> fetchChatMembers(List<String> memberIds) => _service
      .fetchCollection(
          path: DBPath.users(),
          builder: (data) => AppUser.fromMap(data),
          queryBuilder: (query) => query!.where('uid', whereIn: memberIds))
      .then((users) => users.whereType<AppUser>().toList());
}

@Riverpod(keepAlive: true)
AppUserRepository appUserRepository(AppUserRepositoryRef ref) =>
    AppUserRepository(service: ref.watch(firestoreServiceProvider));

@riverpod
FutureOr<AppUser?> appUserFuture(AppUserFutureRef ref, UserID userId) =>
    ref.watch(appUserRepositoryProvider).getAppUser(userId);

@riverpod
FutureOr<List<AppUser>> chatMembersFuture(
        ChatMembersFutureRef ref, List<String> memberIds) =>
    ref.watch(appUserRepositoryProvider).fetchChatMembers(memberIds);

@riverpod
FutureOr<List<AppUser>> appUsersFuture(AppUsersFutureRef ref) =>
    ref.watch(appUserRepositoryProvider).getAppUsers();

final appUserStreamProvider = StreamProvider.autoDispose
    .family<AppUser?, UserID>((ref, userId) =>
        ref.watch(appUserRepositoryProvider).watchAppUser(userId));
