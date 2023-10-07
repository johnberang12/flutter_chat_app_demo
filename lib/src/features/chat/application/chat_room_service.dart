// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_chat_app/src/features/chat/domain/chat_member.dart';
import 'package:flutter_chat_app/src/features/chat/domain/room_activity.dart';
import 'package:flutter_chat_app/src/features/chat/domain/room_members.dart';
import 'package:flutter_chat_app/src/features/chat/util/get_chat_room_id.dart';

import 'package:flutter_chat_app/src/services/firestore/firestore_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../services/firestore/db_path.dart';
import '../../users/domain/app_user.dart';
import '../data/chat_room_repository.dart';
import '../domain/chat.dart';
import '../domain/chat_room.dart';
part 'chat_room_service.g.dart';

class ChatRoomService {
  ChatRoomService({required this.ref});
  final Ref ref;

  ChatRoomRepository _chatRoomRepo() => ref.read(chatRoomRepositoryProvider);
  DocumentReference _chatRoomRef(ChatRoomID chatRoomId) => ref
      .read(firestoreServiceProvider)
      .docRef(docPath: DBPath.chatRoom(chatRoomId));

  Future<ChatRoom> createChatRoom(
      {required ChatRoom? chatRoom,
      required Chat chat,
      required AppUser peerUser}) async {
    if (chatRoom != null) return chatRoom;
    final newChatRoom = _newChatRoom(chat, peerUser);
    await _chatRoomRepo().createChatRoom(newChatRoom);
    return newChatRoom;
  }

  ///used to set lastActivity
  void setLastActivity(
      {required ChatRoomID chatRoomId,
      required Chat chat,
      required WriteBatch batch}) {
    final data = {'activity': _roomActivity(chat).toMap()};
    batch.update(_chatRoomRef(chatRoomId), data);
  }

  ///used to mark last activity as read
  void readLastActivity(
      {required ChatRoom room,
      required UserID userId,
      required WriteBatch batch}) {
    ///dont update if the sender is me
    if (room.activity.read) return;
    if (room.activity.senderId == userId) return;
    final newActivity = room.activity.copyWith(read: true);
    final data = {'activity': newActivity.toMap()};
    batch.update(_chatRoomRef(room.id), data);
  }

  Future<void> exitChatRoom(ChatRoom? chatRoom) async {
    try {
      final userId = ref.read(authRepositoryProvider).currentUser?.uid;
      if (userId == null || chatRoom == null) return;
      final myData = chatRoom.members.members[userId];
      if (myData == null) return;
      final isRoom = myData.isRoom;
      final isTyping = myData.isTyping;
      if (!isTyping && !isRoom) return;
      final myNewData =
          myData.copyWith(isRoom: false, isTyping: false, badgeCount: 0);
      await ref
          .read(chatRoomRepositoryProvider)
          .updateChatRoom(chatRoom.id, {'members.$userId': myNewData.toMap()});
    } catch (e) {
      return;
    }
  }
}

@Riverpod(keepAlive: true)
ChatRoomService chatRoomService(ChatRoomServiceRef ref) =>
    ChatRoomService(ref: ref);

// final chatRoomServiceProvider =
//     Provider<ChatRoomService>((ref) => ChatRoomService(ref: ref));
@riverpod
Stream<ChatRoom?> chatRoomStream(ChatRoomStreamRef ref, ChatRoomID chatRoomId) {
// final userId = ref.read(authRepositoryProvider).currentUser?.uid ?? 'defaultUserId';
// final reversedRoomId = userId + peerId;
  ref.onDispose(() {
    print('chatRoomProvider disposed.....');
  });
  return ref.watch(chatRoomRepositoryProvider).watchChatRoom(chatRoomId);
}

@riverpod
Stream<List<ChatRoom?>> chatRoomsStream(ChatRoomsStreamRef ref) {
  final userId =
      ref.watch(authRepositoryProvider).currentUser?.uid ?? 'dafualtId';

  return ref.watch(chatRoomRepositoryProvider).watchChatRooms(userId);
}

final chatRoomStreamProvider2 =
    StreamProvider.autoDispose.family<ChatRoom?, ChatRoomID>((ref, chatRoomId) {
  ref.onDispose(() {
    print('chatRoomProvider disposed.....');
  });
  return ref.watch(chatRoomRepositoryProvider).watchChatRoom(chatRoomId);
});

extension ChatRoomServiceX on ChatRoomService {
  ChatRoom _newChatRoom(Chat chat, AppUser peerUser) {
    final memberIds = [chat.senderId, chat.receiverId];
    final chatRoom = ChatRoom(
        id: getChatRoomId(chat.senderId, chat.receiverId),
        memberIds: memberIds,
        members: _roomMembers(chat, peerUser),
        activity: _roomActivity(chat));
    return chatRoom;
  }

  RoomMembers _roomMembers(Chat chat, AppUser peerUser) {
    final me = ChatMember(
        userId: chat.senderId, data: ChatMemberData(name: chat.senderName));
    final peer = ChatMember(
        userId: peerUser.uid, data: ChatMemberData(name: peerUser.name));
    final members = RoomMembers().addMembers([me, peer]);
    return members;
  }

  ///create RoomActivity object
  RoomActivity _roomActivity(Chat chat) {
    final now = currentDate();
    final activity = RoomActivity(
        lastMessage: chat.message,
        senderId: chat.senderId,
        createdAt: now,
        senderName: chat.senderName,
        type: chat.photos.isNotEmpty
            ? RoomActivityType.sendAttachment
            : RoomActivityType.sendChat);
    return activity;
  }
}
