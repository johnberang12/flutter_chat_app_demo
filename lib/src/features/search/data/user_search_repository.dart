// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_chat_app/src/features/search/data/search_engine.dart';

import '../../users/domain/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_search_repository.g.dart';

class UserSearchRepository {
  UserSearchRepository({required SearchEngine engine}) : _engine = engine;
  final SearchEngine _engine;

  Future<List<AppUser?>> fetchSearchedUsers(SearchQuery searchQuery) async {
    const index = 'users_index';
    final query = _engine.query(index, searchQuery);
    final results = await _engine.getObjects(
        query: query, builder: (data) => AppUser.fromMap(data));
    return results;
  }
}

@Riverpod(keepAlive: true)
UserSearchRepository userSearchRepository(UserSearchRepositoryRef ref) =>
    UserSearchRepository(engine: ref.watch(searchEngineProvider));
