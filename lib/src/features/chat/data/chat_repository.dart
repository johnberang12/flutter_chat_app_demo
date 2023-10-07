// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/src/services/firestore/db_path.dart';

import '../../../services/firestore/firestore_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../users/domain/app_user.dart';
import '../domain/chat.dart';
import '../domain/chat_room.dart';
part 'chat_repository.g.dart';

class ChatRepository {
  ChatRepository({required FirestoreService service}) : _service = service;
  final FirestoreService _service;

  void batchSetChat(
      {required ChatRoomID chatRoomId,
      required Chat chat,
      required WriteBatch batch}) {
    final chatRef = _service.docRef(docPath: DBPath.chat(chatRoomId, chat.id));
    batch.set(chatRef, chat.toMap());
  }

  Future<List<Chat>> getUnreadChats(ChatRoomID chatRoomId, UserID userId) =>
      _service.fetchCollection(
        path: DBPath.chats(chatRoomId),
        builder: (data) => Chat.fromMap(data),
        queryBuilder: (query) => query!
            .where('read', isEqualTo: true)
            .where('receiverId', isEqualTo: userId),
      );

  Stream<List<Chat>> watchChats(ChatRoomID chatRoomId) =>
      _service.collectionStream(
          path: DBPath.chats(chatRoomId),
          builder: (data) => Chat.fromMap(data));
}

@Riverpod(keepAlive: true)
ChatRepository chatRepository(ChatRepositoryRef ref) =>
    ChatRepository(service: ref.watch(firestoreServiceProvider));

@riverpod
Stream<List<Chat>> chatsStream(ChatsStreamRef ref, ChatRoomID chatRoomId) =>
    ref.watch(chatRepositoryProvider).watchChats(chatRoomId);
