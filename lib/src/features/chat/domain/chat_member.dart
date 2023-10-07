// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../users/domain/app_user.dart';

class ChatMember {
  final UserID userId;
  final ChatMemberData data;
  ChatMember({
    required this.userId,
    required this.data,
  });

  ChatMember copyWith({
    UserID? userId,
    ChatMemberData? data,
  }) {
    return ChatMember(
      userId: userId ?? this.userId,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'data': data.toMap(),
    };
  }

  factory ChatMember.fromMap(Map<String, dynamic> map) {
    return ChatMember(
      userId: map['userId'] ?? "",
      data: ChatMemberData.fromMap(map['data'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMember.fromJson(String source) =>
      ChatMember.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ChatMember(userId: $userId, data: $data)';

  @override
  bool operator ==(covariant ChatMember other) {
    if (identical(this, other)) return true;

    return other.userId == userId && other.data == data;
  }

  @override
  int get hashCode => userId.hashCode ^ data.hashCode;
}

class ChatMemberData {
  ChatMemberData({
    required this.name,
    this.isRoom = false,
    this.isTyping = false,
    this.badgeCount = 0,
  });

  final String name;
  final bool isRoom;
  final bool isTyping;
  final int badgeCount;

  ChatMemberData copyWith({
    String? name,
    bool? isRoom,
    bool? isTyping,
    int? badgeCount,
  }) {
    return ChatMemberData(
      name: name ?? this.name,
      isRoom: isRoom ?? this.isRoom,
      isTyping: isTyping ?? this.isTyping,
      badgeCount: badgeCount ?? this.badgeCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'isRoom': isRoom,
      'isTyping': isTyping,
      'badgeCount': badgeCount,
    };
  }

  factory ChatMemberData.fromMap(Map<String, dynamic> map) {
    return ChatMemberData(
      name: map['name'] ?? "",
      isRoom: map['isRoom'] ?? false,
      isTyping: map['isTyping'] ?? false,
      badgeCount: map['badgeCount'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMemberData.fromJson(String source) =>
      ChatMemberData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatMemberData(name: $name, isRoom: $isRoom, isTyping: $isTyping, badgeCount: $badgeCount)';
  }

  @override
  bool operator ==(covariant ChatMemberData other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.isRoom == isRoom &&
        other.isTyping == isTyping &&
        other.badgeCount == badgeCount;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        isRoom.hashCode ^
        isTyping.hashCode ^
        badgeCount.hashCode;
  }
}
