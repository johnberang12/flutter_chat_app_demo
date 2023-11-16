// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/src/features/chat/application/chat_room_service.dart';
import 'package:flutter_chat_app/src/features/chat/data/chat_repository.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/read_chats/application/read_chats_service.dart';
import 'package:flutter_chat_app/src/features/image/data/image_upload_repository.dart';
import 'package:flutter_chat_app/src/services/firestore/firestore_service.dart';
import 'package:flutter_chat_app/src/services/storage/storage_path.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../users/domain/app_user.dart';
import '../domain/chat.dart';
import '../domain/chat_room.dart';
part 'chat_service.g.dart';

class ChatService {
  ChatService({required this.ref});
  final Ref ref;

  ChatRepository _chatRepo() => ref.read(chatRepositoryProvider);
  ChatRoomService _roomService() => ref.read(chatRoomServiceProvider);

  FirestoreService _firestoreService() => ref.read(firestoreServiceProvider);

  Future<void> sendChat(
      {required ChatRoom? chatRoom,
      required AppUser peerUser,
      required Chat chat,
      required List<File> files}) async {
    if (chat.message.isEmpty && files.isEmpty) return;
    //create chatRoom
    final room = await ref
        .read(chatRoomServiceProvider)
        .createChatRoom(chatRoom: chatRoom, chat: chat, peerUser: peerUser);

    final newChat = await _uploadChatImages(room.id, chat, files);

    await _firestoreService().batchWrite(batchHandler: (batch) async {
      ///set chat
      _chatRepo()
          .batchSetChat(chatRoomId: room.id, chat: newChat, batch: batch);

      ///update chatRoom
      _roomService()
          .setLastActivity(chatRoom: room, chat: newChat, batch: batch);
      await batch.commit();
    });
  }

  Future<void> sendGroupMessage(
      ChatRoom chatRoom, Chat chat, List<File> images) async {
    print('images to upload: $images');

    ///return if message and images are empty.
    if (chat.message.isEmpty && images.isEmpty) return;

    final newChat = await _uploadChatImages(chatRoom.id, chat, images);

    await _firestoreService().batchWrite(batchHandler: (batch) async {
      ///set chat
      _chatRepo()
          .batchSetChat(chatRoomId: chatRoom.id, chat: newChat, batch: batch);

      ///update chatRoom
      _roomService()
          .setLastActivity(chatRoom: chatRoom, chat: newChat, batch: batch);
      await batch.commit();
    });
  }

  Future<Chat> _uploadChatImages(
      ChatRoomID roomId, Chat chat, List<File> files) async {
    final imageUrls = await ref
        .read(imageUploadRepositoryProvider)
        .uploadFileImages(
            path: StoragePath.chatImagePath(roomId, chat.id), files: files);
    if (imageUrls.isEmpty) return chat;
    final newChat = chat.copyWith(photos: imageUrls, type: ChatType.image);
    return newChat;
  }

  Future<(List<Chat>, DocumentSnapshot?)> fetchChats(
      ChatRoomID chatRoomId, int pageSize, DocumentSnapshot? lastDoc) async {
    final result =
        await _chatRepo().fetchPaginatedChats(chatRoomId, pageSize, lastDoc);
    final chats = result.$1;
    if (chats.isNotEmpty) {
      ///the query is reversed so the first is the latest item
      final lastId = chats.first.id;
      print('lastId: $lastId');
      await ref
          .read(readChatsServiceProvider)
          .updateLastReadChat(chatRoomId, lastId);
    }

    return result;
  }
}

@Riverpod(keepAlive: true)
ChatService chatService(ChatServiceRef ref) => ChatService(ref: ref);



    // for (var i = 0; i < 5; i++) {
    //   await Future.delayed(const Duration(microseconds: 1000));
    // }
    //
    //    // // /increment receiver badge
    // _badgeService().incrementBadges(
    //     room: room, increment: true, userId: chat.senderId, batch: batch);

    // ///
    // _typingService().updateTyping(
    //     room: room, isTyping: false, memberId: chat.senderId, batch: batch);