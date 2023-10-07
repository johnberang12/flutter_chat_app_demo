import 'package:flutter_chat_app/src/features/search/data/user_search_repository.dart';
import 'package:flutter_chat_app/src/features/search/domain/search.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../users/domain/app_user.dart';
import '../presentation/searches_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'search_service.g.dart';

class SearchService {
  SearchService({required this.ref});
  final Ref ref;

  Future<void> fetchSearchResults(String search) async {
    if (search.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 500));

      ///update searchProvider
      ref.read(searchQueryProvider.notifier).update((_) => search);

      ///add the search to the search history
      final id = DateTime.now().toIso8601String();
      final newSearch = Search(id: id, title: search);
      ref.read(searchesControllerProvider.notifier).addItem(newSearch);
    }
  }

  // Stream<List<AppUser?>> searchedAppUsers(String search) {
  //   final result = ref.read(appUserRepositoryProvider).watchUsers();
  //   final users = result.map((users) => users
  //       .where((user) => user != null && user.name.contains(search))
  //       .toList());
  //   return users;
  // }
}

@Riverpod(keepAlive: true)
SearchService searchService(SearchServiceRef ref) => SearchService(ref: ref);

final searchQueryProvider = StateProvider((ref) => '');

// @riverpod
// Stream<List<AppUser?>> searchedStreamUsers(SearchedStreamUsersRef ref) {
//   final searchQuery = ref.watch(searchQueryProvider);
//   return ref.watch(searchServiceProvider).searchedAppUsers(searchQuery);
// }

@riverpod
FutureOr<List<AppUser?>> searchedUsers(Ref ref) {
  final searchQuery = ref.watch(searchQueryProvider);
  return ref
      .watch(userSearchRepositoryProvider)
      .fetchSearchedUsers(searchQuery);
}
