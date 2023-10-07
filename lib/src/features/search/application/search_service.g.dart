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
String _$searchedUsersHash() => r'ac2c4f7c6bc31ee035115473e410ca3d3758bab1';

/// See also [searchedUsers].
@ProviderFor(searchedUsers)
final searchedUsersProvider =
    AutoDisposeFutureProvider<List<AppUser?>>.internal(
  searchedUsers,
  name: r'searchedUsersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchedUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SearchedUsersRef = AutoDisposeFutureProviderRef<List<AppUser?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
