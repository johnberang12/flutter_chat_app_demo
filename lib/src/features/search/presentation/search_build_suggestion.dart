import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/search/presentation/searches_controller.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common_widgets/grid_layout.dart';
import '../../../common_widgets/padded_text.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';
import '../domain/search.dart';

class SearchBuildSuggesitons extends ConsumerWidget {
  const SearchBuildSuggesitons({super.key, required this.showResults});
  final void Function(BuildContext) showResults;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searches = ref.watch(searchesControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PaddedText(text: 'Search History'),
        GridLayout(
            itemCount: searches.length,
            itemBuilder: (context, index) => SearchCard(
                search: searches[index],
                submitSearch: (value) {
                  ref
                      .read(suggestionSearchProvider.notifier)
                      .update((_) => value);
                  showResults(context);
                },
                onDelete: (search) => ref
                    .read(searchesControllerProvider.notifier)
                    .removeItem(search)))
      ],
    );
  }
}

class SearchCard extends ConsumerWidget {
  const SearchCard(
      {Key? key,
      required this.search,
      required this.submitSearch,
      required this.onDelete})
      : super(key: key);
  final Search search;
  final void Function(String) submitSearch;
  final void Function(Search) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 9,
              child: InkWell(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
                    child: Text(
                      search.title,
                      style: Styles.k18(context),
                    ),
                  ),
                  onTap: () => submitSearch(search.title)),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
                  child: Icon(
                    Icons.close,
                    size: Sizes.p18,
                  ),
                ),
                onTap: () => onDelete(search),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final suggestionSearchProvider =
    StateProvider.autoDispose<String?>((ref) => null);
