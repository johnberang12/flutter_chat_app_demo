// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/src/features/chat/application/chat_room_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../services/firestore/db_path.dart';
import '../../../../../services/firestore/firestore_service.dart';
import '../../../../authentication/data/auth_repository.dart';
import '../../../data/chat_repository.dart';
import '../../../domain/chat.dart';
import '../../../domain/chat_room.dart';
import '../../chat_badge/application/chat_badge_service.dart';
part 'read_chats_service.g.dart';

class ReadChatsService {
  ReadChatsService({required this.ref});
  final Ref ref;
  ChatBadgeService _badgeService() => ref.read(chatBadgeServiceProvider);
  ChatRoomService _roomService() => ref.read(chatRoomServiceProvider);

  Future<void> readChats(ChatRoom? room) async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (room == null || userId == null) return;
    final receiverData = room.members.members[userId];
    final badgeCount = receiverData?.badgeCount ?? 0;
    final chats =
        await ref.read(chatRepositoryProvider).getUnreadChats(room.id, userId);
    if (chats.isEmpty && badgeCount == 0 && room.activity.read) return;
    await ref.read(firestoreServiceProvider).batchWrite(
        batchHandler: (batch) async {
      ///update all chats
      _readChats(batch, chats, room.id);

      ///update room activity
      _roomService().readLastActivity(room: room, userId: userId, batch: batch);

      ///reset my badge
      _badgeService().incrementBadge(
          room: room, memberId: userId, increment: false, batch: batch);
      await batch.commit();
    });
  }

  void _readChats(WriteBatch batch, List<Chat> chats, ChatRoomID chatRoomId) {
    if (chats.isEmpty) return;
    for (var chat in chats) {
      final chatRef = ref
          .read(firestoreServiceProvider)
          .docRef(docPath: DBPath.chat(chatRoomId, chat.id));
      final data = {'read': true};
      batch.update(chatRef, data);
    }
  }
}

@Riverpod(keepAlive: true)
ReadChatsService readChatsService(ReadChatsServiceRef ref) =>
    ReadChatsService(ref: ref);
