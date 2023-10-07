// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../users/domain/app_user.dart';
import 'chat_member.dart';

/// Represents a collection of chat members for a specific room.
///
/// This class provides methods to easily manage (add, update, remove) members
/// in a chat room. The underlying state (`members`) is immutable, ensuring that
/// the data remains consistent.
class RoomMembers {
  /// Constructs a new `RoomMembers` instance.
  ///
  /// [members] is an optional parameter that can be used to initialize the collection
  /// with a set of chat members.
  RoomMembers([this.members = const {}]);

  /// A map of chat members, with the user ID being the key and the `ChatMemberData` being the value.
  final Map<UserID, ChatMemberData> members;

  // Cache for storing the computed list representation of members.
  // This cache is useful when the toRoomMemberList() method is called
  // frequently to avoid unnecessary recomputation of the list.
  List<ChatMemberData>? _cachedMemberList;

  /// Converts the `RoomMembers` instance into a map.
  Map<String, dynamic> toMap() {
    return members.map((key, value) => MapEntry(key, value.toMap()));
    // return <String, dynamic>{
    //   'members': members.map((key, value) => MapEntry(key, value.toMap())),
    //   // 'members': members
    // };
  }

  /// Constructs a `RoomMembers` instance from a map.
  factory RoomMembers.fromMap(Map<String, dynamic> map) {
    return RoomMembers(
      map.map(
          (key, value) => MapEntry(key, ChatMemberData.fromMap(value ?? {}))),
    );
  }

  /// Converts the `RoomMembers` instance into a JSON string.
  String toJson() => json.encode(toMap());

  /// Constructs a `RoomMembers` instance from a JSON string.
  factory RoomMembers.fromJson(String source) =>
      RoomMembers.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RoomMembers(members: $members)';

  @override
  bool operator ==(covariant RoomMembers other) {
    if (identical(this, other)) return true;

    return mapEquals(other.members, members);
  }

  @override
  int get hashCode => members.hashCode;

  /// Converts the member map to a list.
  /// Uses caching for efficiency in frequent calls.
  List<ChatMemberData> toRoomMemberList() {
    // If cache is null, compute the list and cache it.
    _cachedMemberList ??= members.entries.map((e) => e.value).toList();
    return _cachedMemberList!;
  }
}

/// Provides extension methods on `RoomMembers` to simplify operations
/// related to managing chat members.
/// These methods are for the purpose of mutation
/// to maintain the imutability of the main object
extension MutableRoomMember on RoomMembers {
  /// Returns a new `RoomMembers` instance with an added member.
  RoomMembers addMember(ChatMember member) {
    _cachedMemberList = null;
    final copy = Map<UserID, ChatMemberData>.from(members);
    copy[member.userId] = member.data;
    return RoomMembers(copy);
  }

  /// Returns a new `RoomMembers` instance with multiple added members.
  RoomMembers addMembers(List<ChatMember> users) {
    _cachedMemberList = null;
    final copy = Map<UserID, ChatMemberData>.from(members);
    for (var user in users) {
      copy[user.userId] = user.data;
    }
    return RoomMembers(copy);
  }

  /// Returns a new `RoomMembers` instance with a removed member by [userId].
  RoomMembers removeMember(UserID userId) {
    _cachedMemberList = null;
    final copy = Map<UserID, ChatMemberData>.from(members);
    copy.remove(userId);
    return RoomMembers(copy);
  }

  /// Returns a new `RoomMembers` instance with an updated member data.
  RoomMembers updateMember(ChatMember updatedMember) {
    _cachedMemberList = null;
    final copy = Map<UserID, ChatMemberData>.from(members);
    copy[updatedMember.userId] = updatedMember.data;
    return RoomMembers(copy);
  }
}
