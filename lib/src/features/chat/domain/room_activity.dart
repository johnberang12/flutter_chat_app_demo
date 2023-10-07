// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../users/domain/app_user.dart';

enum RoomActivityType { sendChat, sendAttachment, delete, reaction }

class RoomActivity {
  RoomActivity({
    required this.lastMessage,
    required this.senderId,
    required this.createdAt,
    required this.senderName,
    this.type = RoomActivityType.sendChat,
    this.read = false,
  });
  final String lastMessage;
  final UserID senderId;
  final DateTime createdAt;
  final String senderName;
  final RoomActivityType type;
  final bool read;

  RoomActivity copyWith(
      {String? lastMessage,
      UserID? senderId,
      DateTime? createdAt,
      String? senderName,
      RoomActivityType? type,
      bool? read}) {
    return RoomActivity(
      lastMessage: lastMessage ?? this.lastMessage,
      senderId: senderId ?? this.senderId,
      createdAt: createdAt ?? this.createdAt,
      senderName: senderName ?? this.senderName,
      read: read ?? this.read,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lastMessage': lastMessage,
      'senderId': senderId,
      'createdAt': Timestamp.fromDate(createdAt),
      'senderName': senderName,
      'type': type.name,
      'read': read
    };
  }

  factory RoomActivity.fromMap(Map<String, dynamic> map) {
    RoomActivityType getActivityType(String activityType) {
      for (var value in RoomActivityType.values) {
        if (value.name == activityType) {
          return value;
        }
      }
      return RoomActivityType.sendChat;
    }

    return RoomActivity(
        lastMessage: map['lastMessage'] ?? "",
        senderId: map['senderId'] ?? "",
        createdAt: (map['createdAt'] as Timestamp).toDate(),
        senderName: map['senderName'] ?? "",
        type: getActivityType(map['type'] ?? ""),
        read: map['read'] ?? false);
  }

  String toJson() => json.encode(toMap());

  factory RoomActivity.fromJson(String source) =>
      RoomActivity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RoomActivity(lastMessage: $lastMessage, senderId: $senderId, createdAt: $createdAt, senderName: $senderName, type: $type, read: $read)';
  }

  @override
  bool operator ==(covariant RoomActivity other) {
    if (identical(this, other)) return true;

    return other.lastMessage == lastMessage &&
        other.senderId == senderId &&
        other.createdAt == createdAt &&
        other.senderName == senderName &&
        other.type == type &&
        other.read == read;
  }

  @override
  int get hashCode {
    return lastMessage.hashCode ^
        senderId.hashCode ^
        createdAt.hashCode ^
        senderName.hashCode ^
        type.hashCode ^
        read.hashCode;
  }
}
