// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchServiceHash() => r'f1e530080f78ed01e417c0176796a42537126571';

/// See also [searchService].
@ProviderFor(searchService)
final searchServiceProvider = Provider<SearchService>.internal(
  searchService,
  name: r'searchServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SearchServiceRef = ProviderRef<SearchService>;
String _$searchedStreamUsersHash() =>
    r'2f02b72c57a6e946304ae9a4e89ab6f98479d7fc';

/// See also [searchedStreamUsers].
@ProviderFor(searchedStreamUsers)
final searchedStreamUsersProvider =
    AutoDisposeStreamProvider<List<AppUser>>.internal(
  searchedStreamUsers,
  name: r'searchedStreamUsersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchedStreamUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SearchedStreamUsersRef = AutoDisposeStreamProviderRef<List<AppUser>>;
String _$searchedUsersHash() => r'a42d80808360d66a641c72d3d8ba0be7032cfc21';

/// See also [searchedUsers].
@ProviderFor(searchedUsers)
final searchedUsersProvider = AutoDisposeFutureProvider<List<AppUser>>.internal(
  searchedUsers,
  name: r'searchedUsersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchedUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SearchedUsersRef = AutoDisposeFutureProviderRef<List<AppUser>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
