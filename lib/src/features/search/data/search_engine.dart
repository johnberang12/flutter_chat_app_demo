// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:algolia/algolia.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'search_engine.g.dart';

///a type representing the algolia index name
typedef AlgoliaIndex = String;

///a type representing the search query value
typedef SearchQuery = String;

///a type representing the search filter
typedef SearchFilter = String;

class SearchEngine {
  SearchEngine({
    required Algolia algolia,
  }) : _algolia = algolia;
  final Algolia _algolia;

  AlgoliaIndexReference _index(String indexName) => _algolia.index(indexName);

  AlgoliaQuery query(AlgoliaIndex indexName, SearchQuery searchQuery) =>
      _index(indexName).query(searchQuery);

  Future<List<T>> getObjects<T>(
          {required AlgoliaQuery query,
          required T Function(Map<String, dynamic> data) builder}) =>
      query.getObjects().then(
          (snapshot) => snapshot.hits.map((e) => builder(e.data)).toList());

  AlgoliaQuery filters(AlgoliaQuery query, SearchFilter searchFilter) =>
      query.filters(searchFilter);
  AlgoliaQuery facetFilter(AlgoliaQuery query, SearchFilter searchFilter) =>
      query.facetFilter(searchFilter);
}

@Riverpod(keepAlive: true)
Algolia algolia(AlgoliaRef ref) => Algolia.init(
        applicationId: dotenv.env['ALGOLIA_APPLICATION_ID'] ?? "",
        apiKey: dotenv.env['ALGOLIA_API_KEY'] ?? "")
    .instance;

@Riverpod(keepAlive: true)
SearchEngine searchEngine(SearchEngineRef ref) =>
    SearchEngine(algolia: ref.watch(algoliaProvider));
