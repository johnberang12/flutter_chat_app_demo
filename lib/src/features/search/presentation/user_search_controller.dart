import 'package:flutter_chat_app/src/features/search/application/search_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/search_engine.dart';
part 'user_search_controller.g.dart';

@riverpod
class UserSearchController extends _$UserSearchController {
  @override
  FutureOr<void> build() {}

  Future<void> fetchSearchedUsers(SearchQuery searchQuery) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(searchServiceProvider).fetchSearchResults(searchQuery));
  }
}
