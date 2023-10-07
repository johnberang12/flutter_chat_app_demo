// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutter_chat_app/src/features/users/domain/app_user.dart';

enum ChatType { text, image, attachment }

typedef ChatID = String;

class Chat {
  Chat({
    required this.id,
    required this.message,
    required this.photos,
    this.reactions =
        const ChatReactions(reactionCount: 0, reactions: Reactions()),
    this.type = ChatType.text,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    this.read = false,
    this.active = true,
  });

  final ChatID id;
  final String message;
  final List<String> photos;
  final ChatReactions reactions;
  final ChatType type;
  final UserID senderId;
  final String senderName;
  final UserID receiverId;
  final bool read;
  final bool active;

  Chat copyWith({
    ChatID? id,
    String? message,
    List<String>? photos,
    ChatReactions? reactions,
    ChatType? type,
    UserID? senderId,
    String? senderName,
    UserID? receiverId,
    bool? read,
    bool? active,
  }) {
    return Chat(
      id: id ?? this.id,
      message: message ?? this.message,
      photos: photos ?? this.photos,
      reactions: reactions ?? this.reactions,
      type: type ?? this.type,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      receiverId: receiverId ?? this.receiverId,
      read: read ?? this.read,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'photos': photos,
      'reactions': reactions.toMap(),
      'type': type.name,
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'read': read,
      'active': active,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    ChatType getChatType(String chatType) {
      for (var value in ChatType.values) {
        if (value.name == chatType) {
          return value;
        }
      }
      return ChatType.text;
    }

    return Chat(
      id: map['id'] ?? "",
      message: map['message'] as String,
      photos: List<String>.from(map['photos'] ?? []),
      reactions: ChatReactions.fromMap(map['reactions'] ?? {}),
      type: getChatType(map['type'] ?? ""),
      senderId: map['senderId'] ?? "",
      senderName: map['senderName'] ?? "",
      receiverId: map['receiverId'] ?? "",
      read: map['read'] ?? false,
      active: map['active'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chat(id: $id, message: $message, photos: $photos, reactions: $reactions, type: $type, senderId: $senderId, senderName: $senderName, receiverId: $receiverId, read: $read, active: $active)';
  }

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.message == message &&
        listEquals(other.photos, photos) &&
        other.reactions == reactions &&
        other.type == type &&
        other.senderId == senderId &&
        other.senderName == senderName &&
        other.receiverId == receiverId &&
        other.read == read &&
        other.active == active;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        message.hashCode ^
        photos.hashCode ^
        reactions.hashCode ^
        type.hashCode ^
        senderId.hashCode ^
        senderName.hashCode ^
        receiverId.hashCode ^
        read.hashCode ^
        active.hashCode;
  }
}

class ChatReactions {
  const ChatReactions({
    required this.reactionCount,
    this.reactions = const Reactions(),
  });
  final int reactionCount;
  final Reactions reactions;

  @override
  String toString() =>
      'ChatReactions(reactionCount: $reactionCount, reactions: $reactions)';

  @override
  bool operator ==(covariant ChatReactions other) {
    if (identical(this, other)) return true;

    return other.reactionCount == reactionCount && other.reactions == reactions;
  }

  @override
  int get hashCode => reactionCount.hashCode ^ reactions.hashCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reactionCount': reactionCount,
      'reactions': reactions.toMap(),
    };
  }

  factory ChatReactions.fromMap(Map<String, dynamic> map) {
    return ChatReactions(
      reactionCount: map['reactionCount'] ?? 0,
      reactions: Reactions.fromMap(map['reactions'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatReactions.fromJson(String source) =>
      ChatReactions.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Reactions {
  const Reactions([this.reaction = const {}]);
  final Map<UserID, dynamic> reaction;

  Map<String, dynamic> toMap() {
    return reaction.map((key, value) => MapEntry(key, value));
  }

  factory Reactions.fromMap(Map<String, dynamic> map) {
    return Reactions(map.map((key, value) => MapEntry(key, value)));
  }

  @override
  String toString() => 'Reactions(reaction: $reaction)';

  @override
  bool operator ==(covariant Reactions other) {
    if (identical(this, other)) return true;

    return mapEquals(other.reaction, reaction);
  }

  @override
  int get hashCode => reaction.hashCode;
}
