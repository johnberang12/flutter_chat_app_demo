// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRepositoryHash() => r'56f8f507703bc2e40058f9a6594c634690371a94';

/// See also [chatRepository].
@ProviderFor(chatRepository)
final chatRepositoryProvider = Provider<ChatRepository>.internal(
  chatRepository,
  name: r'chatRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatRepositoryRef = ProviderRef<ChatRepository>;
String _$chatsStreamHash() => r'a4b09b9cd2f868621e1b8d562dcea3892f6e7812';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef ChatsStreamRef = AutoDisposeStreamProviderRef<List<Chat>>;

/// See also [chatsStream].
@ProviderFor(chatsStream)
const chatsStreamProvider = ChatsStreamFamily();

/// See also [chatsStream].
class ChatsStreamFamily extends Family<AsyncValue<List<Chat>>> {
  /// See also [chatsStream].
  const ChatsStreamFamily();

  /// See also [chatsStream].
  ChatsStreamProvider call(
    String chatRoomId,
  ) {
    return ChatsStreamProvider(
      chatRoomId,
    );
  }

  @override
  ChatsStreamProvider getProviderOverride(
    covariant ChatsStreamProvider provider,
  ) {
    return call(
      provider.chatRoomId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chatsStreamProvider';
}

/// See also [chatsStream].
class ChatsStreamProvider extends AutoDisposeStreamProvider<List<Chat>> {
  /// See also [chatsStream].
  ChatsStreamProvider(
    this.chatRoomId,
  ) : super.internal(
          (ref) => chatsStream(
            ref,
            chatRoomId,
          ),
          from: chatsStreamProvider,
          name: r'chatsStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatsStreamHash,
          dependencies: ChatsStreamFamily._dependencies,
          allTransitiveDependencies:
              ChatsStreamFamily._allTransitiveDependencies,
        );

  final String chatRoomId;

  @override
  bool operator ==(Object other) {
    return other is ChatsStreamProvider && other.chatRoomId == chatRoomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatRoomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$paginatedChatsStreamHash() =>
    r'bf2d35334ca94ccc7379adc34155e9e2c9874a09';
typedef PaginatedChatsStreamRef
    = AutoDisposeStreamProviderRef<(List<Chat>, DocumentSnapshot<Object?>?)>;

/// See also [paginatedChatsStream].
@ProviderFor(paginatedChatsStream)
const paginatedChatsStreamProvider = PaginatedChatsStreamFamily();

/// See also [paginatedChatsStream].
class PaginatedChatsStreamFamily
    extends Family<AsyncValue<(List<Chat>, DocumentSnapshot<Object?>?)>> {
  /// See also [paginatedChatsStream].
  const PaginatedChatsStreamFamily();

  /// See also [paginatedChatsStream].
  PaginatedChatsStreamProvider call(
    String chatRoomId,
    int pageSize,
    DocumentSnapshot<Object?>? documentSnapshot,
  ) {
    return PaginatedChatsStreamProvider(
      chatRoomId,
      pageSize,
      documentSnapshot,
    );
  }

  @override
  PaginatedChatsStreamProvider getProviderOverride(
    covariant PaginatedChatsStreamProvider provider,
  ) {
    return call(
      provider.chatRoomId,
      provider.pageSize,
      provider.documentSnapshot,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'paginatedChatsStreamProvider';
}

/// See also [paginatedChatsStream].
class PaginatedChatsStreamProvider extends AutoDisposeStreamProvider<
    (List<Chat>, DocumentSnapshot<Object?>?)> {
  /// See also [paginatedChatsStream].
  PaginatedChatsStreamProvider(
    this.chatRoomId,
    this.pageSize,
    this.documentSnapshot,
  ) : super.internal(
          (ref) => paginatedChatsStream(
            ref,
            chatRoomId,
            pageSize,
            documentSnapshot,
          ),
          from: paginatedChatsStreamProvider,
          name: r'paginatedChatsStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$paginatedChatsStreamHash,
          dependencies: PaginatedChatsStreamFamily._dependencies,
          allTransitiveDependencies:
              PaginatedChatsStreamFamily._allTransitiveDependencies,
        );

  final String chatRoomId;
  final int pageSize;
  final DocumentSnapshot<Object?>? documentSnapshot;

  @override
  bool operator ==(Object other) {
    return other is PaginatedChatsStreamProvider &&
        other.chatRoomId == chatRoomId &&
        other.pageSize == pageSize &&
        other.documentSnapshot == documentSnapshot;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatRoomId.hashCode);
    hash = _SystemHash.combine(hash, pageSize.hashCode);
    hash = _SystemHash.combine(hash, documentSnapshot.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
