// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../services/firestore/firestore_service.dart';
import '../../../data/chat_room_repository.dart';
import '../../../domain/chat_room.dart';
part 'delete_chat_room_service.g.dart';

class DeleteChatRoomService {
  DeleteChatRoomService({required this.ref});
  final Ref ref;
  ChatRoomRepository _chatRoomRepo() => ref.read(chatRoomRepositoryProvider);

  Future<void> deleteChatRoom(ChatRoom chatRoom) async {
    final now = currentDate();
    final newRoom = chatRoom.copyWith(deletedAt: now, deleted: true);
    await _chatRoomRepo().createChatRoom(newRoom);
  }

  Future<void> undoDeletion(ChatRoomID roomId) async {
    final data = {'deletedAt': FieldValue.delete(), 'deleted': false};
    await _chatRoomRepo().updateChatRoom(roomId, data);
  }
}

@Riverpod(keepAlive: true)
DeleteChatRoomService deleteChatRoomService(DeleteChatRoomServiceRef ref) =>
    DeleteChatRoomService(ref: ref);
