import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/search/application/search_service.dart';
import 'package:flutter_chat_app/src/features/search/presentation/search_build_suggestion.dart';

import 'package:flutter_chat_app/src/features/users/common_widget/users_fetch_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchScreen extends SearchDelegate {
  SearchScreen({required this.ref});
  final WidgetRef ref;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty) ...[
        IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
      ],
      IconButton(
          onPressed: () => showResults(context),
          icon: const Icon(Icons.search)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SearchBuildResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _submitSearch(query);
    });
    return query.isEmpty
        ? SearchBuildSuggesitons(showResults: showResults)
        : const SearchBuildResults();
  }

  Future<void> _submitSearch(String search) async {
    final finalQuery = ref.read(suggestionSearchProvider) ?? search;
    ref.read(searchServiceProvider).fetchSearchResults(finalQuery);
  }

  @override
  void showResults(BuildContext context) {
    super.showResults(context);
    _submitSearch(query);
  }

  @override
  InputDecorationTheme? get searchFieldDecorationTheme => InputDecorationTheme(
      contentPadding: const EdgeInsets.all(12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)));

  @override
  String? get searchFieldLabel => 'Looking for Forever...?';
}

class SearchBuildResults extends ConsumerWidget {
  const SearchBuildResults({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersValue = ref.watch(searchedUsersProvider);
    return UsersFetchWidget(usersValue: usersValue);
  }
}
