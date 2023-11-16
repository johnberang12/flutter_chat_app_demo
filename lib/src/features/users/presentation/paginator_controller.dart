// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_chat_app/src/features/users/data/app_user_repository.dart';

import '../domain/app_user.dart';

class PaginatorController extends AutoDisposeAsyncNotifier<List<AppUser>> {
  bool get hasMore => _hasMore;
  final int pageSize = 10;
  bool _hasMore = true;
  DocumentSnapshot? _lastDoc;

  AppUserRepository _repository() => ref.read(appUserRepositoryProvider);

  @override
  FutureOr<List<AppUser>> build() async {
    state = const AsyncLoading();

    final newState = await AsyncValue.guard(() => _fetchUsers(pageSize, null));

    state = newState;

    return state.hasError ? [] : state.value ?? [];
    // return _fetchUsers(pageSize, null);
  }

  Future<void> fetchMore({bool isRefresh = false}) async {
    if (state.isLoading || _lastDoc == null) return;

    state = const AsyncLoading();

    final newState = await AsyncValue.guard(() async {
      final newUsers = await _fetchUsers(pageSize, isRefresh ? null : _lastDoc);
      return isRefresh ? newUsers : [...?state.value, ...newUsers];
    });
    state = newState;
  }

  Future<List<AppUser>> _fetchUsers(
      int pageSize, DocumentSnapshot? lastDoc) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // throw Exception('something went wrong...');

    final result = await _repository()
        .fetchPaginatedUsers(pageSize: pageSize, docSnapshot: lastDoc);

    _hasMore = result.$1.isNotEmpty;

    final lastDocument = result.$2;

    if (lastDocument != null) {
      _lastDoc = lastDocument;
    }

    return result.$1;
  }
}

final paginatorControllerProvider =
    AsyncNotifierProvider.autoDispose<PaginatorController, List<AppUser>>(
        PaginatorController.new);
