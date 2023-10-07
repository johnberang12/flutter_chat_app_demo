import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';
import '../domain/search.dart';

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
