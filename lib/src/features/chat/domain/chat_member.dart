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

// roomMembers = {
//   'userId1': {
//     'uid': 'userId1',
//     'isAdmin': true,
//     'name': 'user_name',
//     'isRoom': false,
//     'isTyping': false,
//     'badgeCount': 0,
//     'imageUrl': 'photoUrl',
//     'lastReadChat': 'chatId',
//   },
//     'userId2': {
//     'uid': 'userId2',
//     'isAdmin': true,
//     'name': 'user_name',
//     'isRoom': false,
//     'isTyping': false,
//     'badgeCount': 0,
//     'imageUrl': 'photoUrl',
//     'lastReadChat': 'chatId',
//   },
//     'userId3': {
//     'uid': 'userId3',
//     'isAdmin': true,
//     'name': 'user_name',
//     'isRoom': false,
//     'isTyping': false,
//     'badgeCount': 0,
//     'imageUrl': 'photoUrl',
//     'lastReadChat': 'chatId',
//   }
// };

class ChatMemberData {
  ChatMemberData({
    required this.uid,
    this.isAdmin = false,
    required this.name,
    this.isRoom = false,
    this.isTyping = false,
    this.badgeCount = 0,
    this.imageUrl = '',
    this.lastReadChat = '',
  });
  final UserID uid;
  final bool isAdmin;
  final String name;
  final bool isRoom;
  final bool isTyping;
  final int badgeCount;
  final String imageUrl;
  final String lastReadChat;

  ChatMemberData copyWith({
    UserID? uid,
    bool? isAdmin,
    String? name,
    bool? isRoom,
    bool? isTyping,
    int? badgeCount,
    String? imageUrl,
    String? lastReadChat,
  }) {
    return ChatMemberData(
      uid: uid ?? this.uid,
      isAdmin: isAdmin ?? this.isAdmin,
      name: name ?? this.name,
      isRoom: isRoom ?? this.isRoom,
      isTyping: isTyping ?? this.isTyping,
      badgeCount: badgeCount ?? this.badgeCount,
      imageUrl: imageUrl ?? this.imageUrl,
      lastReadChat: lastReadChat ?? this.lastReadChat,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'isAdmin': isAdmin,
      'name': name,
      'isRoom': isRoom,
      'isTyping': isTyping,
      'badgeCount': badgeCount,
      'imageUrl': imageUrl,
      'lastReadChat': lastReadChat,
    };
  }

  factory ChatMemberData.fromMap(Map<String, dynamic> map) {
    return ChatMemberData(
        uid: map['uid'] ?? '',
        isAdmin: map['isAdmin'] ?? false,
        name: map['name'] ?? "",
        isRoom: map['isRoom'] ?? false,
        isTyping: map['isTyping'] ?? false,
        badgeCount: map['badgeCount'] ?? 0,
        imageUrl: map['imageUrl'] ?? '',
        lastReadChat: map['lastReadChat'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory ChatMemberData.fromJson(String source) =>
      ChatMemberData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatMemberData(uid: $uid, isAdmin: $isAdmin, name: $name, isRoom: $isRoom, isTyping: $isTyping, badgeCount: $badgeCount, imageUrl: $imageUrl, lastReadChat: $lastReadChat)';
  }

  @override
  bool operator ==(covariant ChatMemberData other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.isAdmin == isAdmin &&
        other.name == name &&
        other.isRoom == isRoom &&
        other.isTyping == isTyping &&
        other.badgeCount == badgeCount &&
        other.imageUrl == imageUrl &&
        other.lastReadChat == lastReadChat;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        isAdmin.hashCode ^
        name.hashCode ^
        isRoom.hashCode ^
        isTyping.hashCode ^
        badgeCount.hashCode ^
        imageUrl.hashCode ^
        lastReadChat.hashCode;
  }
}
