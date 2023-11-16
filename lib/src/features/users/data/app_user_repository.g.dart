// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appUserRepositoryHash() => r'699a022b9ba1768f1a12897ea78e1eb8528771fa';

/// See also [appUserRepository].
@ProviderFor(appUserRepository)
final appUserRepositoryProvider = Provider<AppUserRepository>.internal(
  appUserRepository,
  name: r'appUserRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appUserRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppUserRepositoryRef = ProviderRef<AppUserRepository>;
String _$appUserFutureHash() => r'9b35d87c4d6e18d05d25978e50cff0592185d51c';

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

typedef AppUserFutureRef = AutoDisposeFutureProviderRef<AppUser?>;

/// See also [appUserFuture].
@ProviderFor(appUserFuture)
const appUserFutureProvider = AppUserFutureFamily();

/// See also [appUserFuture].
class AppUserFutureFamily extends Family<AsyncValue<AppUser?>> {
  /// See also [appUserFuture].
  const AppUserFutureFamily();

  /// See also [appUserFuture].
  AppUserFutureProvider call(
    String userId,
  ) {
    return AppUserFutureProvider(
      userId,
    );
  }

  @override
  AppUserFutureProvider getProviderOverride(
    covariant AppUserFutureProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'appUserFutureProvider';
}

/// See also [appUserFuture].
class AppUserFutureProvider extends AutoDisposeFutureProvider<AppUser?> {
  /// See also [appUserFuture].
  AppUserFutureProvider(
    this.userId,
  ) : super.internal(
          (ref) => appUserFuture(
            ref,
            userId,
          ),
          from: appUserFutureProvider,
          name: r'appUserFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$appUserFutureHash,
          dependencies: AppUserFutureFamily._dependencies,
          allTransitiveDependencies:
              AppUserFutureFamily._allTransitiveDependencies,
        );

  final String userId;

  @override
  bool operator ==(Object other) {
    return other is AppUserFutureProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$chatMembersFutureHash() => r'ddb64fbb1fc93cc2d9833dae3c6c8a86857bb66e';
typedef ChatMembersFutureRef = AutoDisposeFutureProviderRef<List<AppUser>>;

/// See also [chatMembersFuture].
@ProviderFor(chatMembersFuture)
const chatMembersFutureProvider = ChatMembersFutureFamily();

/// See also [chatMembersFuture].
class ChatMembersFutureFamily extends Family<AsyncValue<List<AppUser>>> {
  /// See also [chatMembersFuture].
  const ChatMembersFutureFamily();

  /// See also [chatMembersFuture].
  ChatMembersFutureProvider call(
    List<String> memberIds,
  ) {
    return ChatMembersFutureProvider(
      memberIds,
    );
  }

  @override
  ChatMembersFutureProvider getProviderOverride(
    covariant ChatMembersFutureProvider provider,
  ) {
    return call(
      provider.memberIds,
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
  String? get name => r'chatMembersFutureProvider';
}

/// See also [chatMembersFuture].
class ChatMembersFutureProvider
    extends AutoDisposeFutureProvider<List<AppUser>> {
  /// See also [chatMembersFuture].
  ChatMembersFutureProvider(
    this.memberIds,
  ) : super.internal(
          (ref) => chatMembersFuture(
            ref,
            memberIds,
          ),
          from: chatMembersFutureProvider,
          name: r'chatMembersFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatMembersFutureHash,
          dependencies: ChatMembersFutureFamily._dependencies,
          allTransitiveDependencies:
              ChatMembersFutureFamily._allTransitiveDependencies,
        );

  final List<String> memberIds;

  @override
  bool operator ==(Object other) {
    return other is ChatMembersFutureProvider && other.memberIds == memberIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, memberIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$appUsersFutureHash() => r'4f06afdcfe4175edd7b3c7cec8609fe36a7da6ec';

/// See also [appUsersFuture].
@ProviderFor(appUsersFuture)
final appUsersFutureProvider =
    AutoDisposeFutureProvider<List<AppUser>>.internal(
  appUsersFuture,
  name: r'appUsersFutureProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appUsersFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppUsersFutureRef = AutoDisposeFutureProviderRef<List<AppUser>>;

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
