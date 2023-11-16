// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../services/firestore/db_path.dart';
import '../../../../../services/firestore/firestore_service.dart';
import '../../../../authentication/data/auth_repository.dart';
import '../../../../users/domain/app_user.dart';
import '../../../data/chat_room_repository.dart';
import '../../../domain/chat_room.dart';
part 'typing_service.g.dart';

class TypingService {
  final Ref ref;
  TypingService({
    required this.ref,
  });

  DocumentReference _chatRoomRef(ChatRoomID chatRoomId) => ref
      .read(firestoreServiceProvider)
      .docRef(docPath: DBPath.chatRoom(chatRoomId));

  ///used to toggle the typing indicator when typing an when exiting the
  ///chat room screen
  Future<void> toggleTyping(ChatRoom room, bool isTyping) async {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) return;
    final userData = room.members.members[userId];
    if (userData == null) return;
    final typing = userData.isTyping;
    if (typing == isTyping) return;
    final newUserData = userData.copyWith(isTyping: isTyping);
    final data = {'members.$userId': newUserData.toMap()};
    await ref.read(chatRoomRepositoryProvider).updateChatRoom(room.id, data);
  }

  ///used to toggle typing indicator

  void updateTyping(
      {required ChatRoom room,
      required UserID memberId,
      required bool isTyping,
      required WriteBatch batch}) {
    final memberData = room.members.members[memberId];
    if (memberData != null) {
      ///update typing to true
      final newData = memberData.copyWith(isTyping: isTyping);
      final data = {'members.$memberId': newData.toMap()};
      batch.update(_chatRoomRef(room.id), data);
    }
  }
}

@Riverpod(keepAlive: true)
TypingService typingService(TypingServiceRef ref) => TypingService(ref: ref);
