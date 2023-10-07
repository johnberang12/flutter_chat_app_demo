// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../services/firestore/db_path.dart';
import '../../../../../services/firestore/firestore_service.dart';
import '../../../../users/domain/app_user.dart';
import '../../../domain/chat_room.dart';
part 'chat_badge_service.g.dart';

class ChatBadgeService {
  ChatBadgeService({required this.ref});
  final Ref ref;

  DocumentReference _chatRoomRef(ChatRoomID chatRoomId) => ref
      .read(firestoreServiceProvider)
      .docRef(docPath: DBPath.chatRoom(chatRoomId));

  ///used to increment or reset badge count
  void incrementBadge(
      {required ChatRoom room,
      required UserID memberId,
      required bool increment,
      required WriteBatch batch}) {
    final receiverData = room.members.members[memberId];
    if (receiverData != null) {
      ///increment badge count
      final badgeCount = increment ? receiverData.badgeCount + 1 : 0;
      final newData = receiverData.copyWith(badgeCount: badgeCount);
      final data = {'members.$memberId': newData.toMap()};
      batch.update(_chatRoomRef(room.id), data);
    }
  }
}

@Riverpod(keepAlive: true)
ChatBadgeService chatBadgeService(ChatBadgeServiceRef ref) =>
    ChatBadgeService(ref: ref);
