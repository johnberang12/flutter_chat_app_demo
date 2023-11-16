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

import '../../users/domain/app_user.dart';
import '../data/chat_room_repository.dart';
import '../domain/chat.dart';
import '../domain/chat_room.dart';
part 'chat_room_service.g.dart';

class ChatRoomService {
  ChatRoomService({required this.ref});
  final Ref ref;

  ChatRoomRepository _chatRoomRepo() => ref.read(chatRoomRepositoryProvider);

  Future<ChatRoom> createChatRoom(
      {required ChatRoom? chatRoom,
      required Chat chat,
      required AppUser peerUser}) async {
    if (chatRoom != null) return chatRoom;
    final userPhotoUrl =
        ref.read(authRepositoryProvider).currentUser?.photoURL ?? "";
    final newChatRoom = _createNewChatRoom(chat, peerUser, userPhotoUrl);
    await _chatRoomRepo().createChatRoom(newChatRoom);
    return newChatRoom;
  }

  ///used to set lastActivity
  void setLastActivity(
      {required ChatRoom chatRoom,
      required Chat chat,
      required WriteBatch batch}) {
    final updatedMembers = {
      //iterate to all chat members
      for (var entry in chatRoom.members.members.entries)
        entry.key: entry.key == chat.senderId
            ? entry.value
                .copyWith(isTyping: false, lastReadChat: chat.id)
                .toMap() //update typing to false and lastReadChat for the sender
            : entry.value
                .copyWith(badgeCount: entry.value.badgeCount + 1)
                .toMap() //increment badgeCount of the receivers
    };

    final data = {
      'activity': _createRoomActivity(chat).toMap(),
      'members': updatedMembers //conver the entry values to map
    };

    _chatRoomRepo()
        .batchUpdateChatRoom(chatRoomId: chatRoom.id, data: data, batch: batch);
  }

  ///used to mark last activity as read
  void readLastActivity(
      {required ChatRoom room,
      required UserID userId,
      required WriteBatch batch}) {
    ///dont update if the sender is me
    if (room.activity.read.contains(userId)) return;
    if (room.activity.senderId == userId) return;
    final newActivity =
        room.activity.copyWith(read: [...room.activity.read, userId]);
    final data = {'activity': newActivity.toMap()};
    _chatRoomRepo()
        .batchUpdateChatRoom(chatRoomId: room.id, data: data, batch: batch);
  }

  Future<void> exitChatRoom(ChatRoom chatRoom) async {
    try {
      final userId = ref.read(authRepositoryProvider).currentUser?.uid;
      if (userId == null) return;
      final myData = chatRoom.members.members[userId];
      if (myData == null) return;
      final isRoom = myData.isRoom;
      final isTyping = myData.isTyping;
      if (!isTyping && !isRoom) return;
      final myNewData =
          myData.copyWith(isRoom: false, isTyping: false, badgeCount: 0);
      await _chatRoomRepo()
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
  final repo = ref.watch(chatRoomRepositoryProvider);

  // ref.onDispose(() {});
  return repo.watchChatRoom(chatRoomId);
}

@riverpod
Stream<List<ChatRoom?>> chatRoomsStream(ChatRoomsStreamRef ref) {
  final userId =
      ref.watch(authRepositoryProvider).currentUser?.uid ?? 'dafualtId';

  return ref.watch(chatRoomRepositoryProvider).watchChatRooms(userId);
}

// final chatRoomStreamProvider2 =
//     StreamProvider.autoDispose.family<ChatRoom?, ChatRoomID>((ref, chatRoomId) {
//   ref.onDispose(() {});
//   return ref.watch(chatRoomRepositoryProvider).watchChatRoom(chatRoomId);
// });

extension ChatRoomServiceX on ChatRoomService {
  ChatRoom _createNewChatRoom(
      Chat chat, AppUser peerUser, String userPhotoUrl) {
    final memberIds = [chat.senderId, peerUser.uid];
    final chatRoom = ChatRoom(
        id: getChatRoomId(chat.senderId, peerUser.uid),
        memberIds: memberIds,
        members: _createPrivateRoomMembers(chat, peerUser, userPhotoUrl),
        activity: _createRoomActivity(chat));
    return chatRoom;
  }

  RoomMembers _createPrivateRoomMembers(
      Chat chat, AppUser peerUser, String userPhotoUrl) {
    final me = ChatMember(
        userId: chat.senderId,
        data: ChatMemberData(
            uid: chat.senderId, name: chat.senderName, imageUrl: userPhotoUrl));

    final peerMember = ChatMember(
        userId: peerUser.uid,
        data: ChatMemberData(
            uid: peerUser.uid,
            name: peerUser.name,
            imageUrl: peerUser.photoUrl));
    final members = RoomMembers().addMembers([me, peerMember]);
    return members;
  }

  ///create RoomActivity object
  RoomActivity _createRoomActivity(Chat chat) {
    final now = currentDate();
    final activity = RoomActivity(
        read: [chat.senderId],
        lastMessage: chat.message,
        senderId: chat.senderId,
        createdAt: now,
        senderName: chat.senderName,
        type: chat.photos.isNotEmpty
            ? RoomActivityType.sendAttachment
            : RoomActivityType.sendChat);
    // print('chat: $chat');

    return activity;
  }
}
