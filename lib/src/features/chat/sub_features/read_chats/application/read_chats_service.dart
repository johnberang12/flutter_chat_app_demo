// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_chat_app/src/features/chat/application/chat_room_service.dart';
import 'package:flutter_chat_app/src/features/chat/data/chat_room_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../authentication/data/auth_repository.dart';
import '../../../domain/chat.dart';
import '../../../domain/chat_room.dart';
part 'read_chats_service.g.dart';

class ReadChatsService {
  ReadChatsService({required this.ref});
  final Ref ref;

  ChatRoomRepository _roomRepo() => ref.read(chatRoomRepositoryProvider);

  Future<void> updateLastReadChat(
      ChatRoomID chatRoomId, ChatID lastChatId) async {
    final chatRoom = await ref.read(chatRoomStreamProvider(chatRoomId).future);
    if (chatRoom == null) return;

    final userId = ref.read(authRepositoryProvider).currentUser?.uid;

    ///return if userId is null
    if (userId == null) return;

    final newActivity = chatRoom.activity
        .copyWith(read: {...chatRoom.activity.read, userId}.toList())
        .toMap();

    final userData = chatRoom.members.members[userId];
    if (userData == null || userData.lastReadChat == lastChatId) return;

    final newUserData =
        userData.copyWith(lastReadChat: lastChatId, badgeCount: 0).toMap();
    final data = {'activity': newActivity, 'members.$userId': newUserData};

    try {
      await _roomRepo().updateChatRoom(chatRoom.id, data);
    } catch (e) {
      ///this is a background process so error should not be propagated
      return;
    }
  }
}

@Riverpod(keepAlive: true)
ReadChatsService readChatsService(ReadChatsServiceRef ref) =>
    ReadChatsService(ref: ref);
