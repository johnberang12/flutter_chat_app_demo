// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/src/features/chat/application/chat_room_service.dart';
import 'package:flutter_chat_app/src/features/chat/data/chat_repository.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/chat_badge/application/chat_badge_service.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/typing_indicator/application/typing_service.dart';
import 'package:flutter_chat_app/src/services/firestore/firestore_service.dart';
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
  TypingService _typingService() => ref.read(typingServiceProvider);
  ChatBadgeService _badgeService() => ref.read(chatBadgeServiceProvider);

  Future<void> sendChat(
      {required ChatRoom? chatRoom,
      required AppUser peerUser,
      required Chat chat,
      required List<File> files}) async {
    if (chat.message.isEmpty && files.isEmpty) return;
    final room = await ref
        .read(chatRoomServiceProvider)
        .createChatRoom(chatRoom: chatRoom, chat: chat, peerUser: peerUser);
    await ref.read(firestoreServiceProvider).batchWrite(
        batchHandler: (batch) async {
      _chatRepo().batchSetChat(chatRoomId: room.id, chat: chat, batch: batch);
      _updateChatRoom(room: room, chat: chat, batch: batch);
      await batch.commit();
    });
  }

  void _updateChatRoom(
      {required ChatRoom room, required Chat chat, required WriteBatch batch}) {
    _roomService()
        .setLastActivity(chatRoomId: room.id, chat: chat, batch: batch);

    ///increment receiver badge
    _badgeService().incrementBadge(
        room: room, increment: true, memberId: chat.receiverId, batch: batch);

    ///
    _typingService().updateTyping(
        room: room, isTyping: false, memberId: chat.senderId, batch: batch);
  }
}

@Riverpod(keepAlive: true)
ChatService chatService(ChatServiceRef ref) => ChatService(ref: ref);
