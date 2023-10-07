// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRoomServiceHash() => r'0cfcb22b4f768a22c276d449cceb5eb758e7d5ff';

/// See also [chatRoomService].
@ProviderFor(chatRoomService)
final chatRoomServiceProvider = Provider<ChatRoomService>.internal(
  chatRoomService,
  name: r'chatRoomServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRoomServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatRoomServiceRef = ProviderRef<ChatRoomService>;
String _$chatRoomStreamHash() => r'6cf232fbedbacdb8c881b80f5cdeebfe22e1f4c0';

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

typedef ChatRoomStreamRef = AutoDisposeStreamProviderRef<ChatRoom?>;

/// See also [chatRoomStream].
@ProviderFor(chatRoomStream)
const chatRoomStreamProvider = ChatRoomStreamFamily();

/// See also [chatRoomStream].
class ChatRoomStreamFamily extends Family<AsyncValue<ChatRoom?>> {
  /// See also [chatRoomStream].
  const ChatRoomStreamFamily();

  /// See also [chatRoomStream].
  ChatRoomStreamProvider call(
    String chatRoomId,
  ) {
    return ChatRoomStreamProvider(
      chatRoomId,
    );
  }

  @override
  ChatRoomStreamProvider getProviderOverride(
    covariant ChatRoomStreamProvider provider,
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
  String? get name => r'chatRoomStreamProvider';
}

/// See also [chatRoomStream].
class ChatRoomStreamProvider extends AutoDisposeStreamProvider<ChatRoom?> {
  /// See also [chatRoomStream].
  ChatRoomStreamProvider(
    this.chatRoomId,
  ) : super.internal(
          (ref) => chatRoomStream(
            ref,
            chatRoomId,
          ),
          from: chatRoomStreamProvider,
          name: r'chatRoomStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatRoomStreamHash,
          dependencies: ChatRoomStreamFamily._dependencies,
          allTransitiveDependencies:
              ChatRoomStreamFamily._allTransitiveDependencies,
        );

  final String chatRoomId;

  @override
  bool operator ==(Object other) {
    return other is ChatRoomStreamProvider && other.chatRoomId == chatRoomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatRoomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$chatRoomsStreamHash() => r'ddab49430388dd3c1fb527395ce8a53db30e0dca';

/// See also [chatRoomsStream].
@ProviderFor(chatRoomsStream)
final chatRoomsStreamProvider =
    AutoDisposeStreamProvider<List<ChatRoom?>>.internal(
  chatRoomsStream,
  name: r'chatRoomsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRoomsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatRoomsStreamRef = AutoDisposeStreamProviderRef<List<ChatRoom?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
