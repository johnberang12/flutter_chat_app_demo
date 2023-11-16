// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/src/services/firestore/db_path.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
            .where('senderId', isNotEqualTo: userId),
      );

  Future<(List<Chat>, DocumentSnapshot?)> fetchPaginatedChats(
          ChatRoomID chatRoomId, int pageSize, DocumentSnapshot? lastDoc) =>
      _service.fetchPaginatedData(
          path: DBPath.chats(chatRoomId),
          builder: (data) => Chat.fromMap(data),
          queryBuilder: (query) {
            Query newQuery =
                query!.orderBy('id', descending: true).limit(pageSize);
            if (lastDoc != null) {
              newQuery = newQuery.startAfterDocument(lastDoc);
            }
            return newQuery;
          });

  Query<Chat> chatsQuery(ChatRoomID chatRoomId) =>
      _service.collectionQuery<Chat>(
          path: DBPath.chats(chatRoomId),
          fromMap: (data, _) => Chat.fromMap(data.data() ?? {}),
          toMap: (chat, _) => chat.toMap(),
          queryBuilder: (query) => query!.orderBy('id', descending: true));

  Stream<List<Chat>> watchChats(ChatRoomID chatRoomId) =>
      _service.collectionStream(
        path: DBPath.chats(chatRoomId),
        builder: (data) => Chat.fromMap(data),
        // queryBuilder: (query) => query!.orderBy('id', descending: true)
      );

  Stream<(List<Chat>, DocumentSnapshot?)> watchPaginatedChats(
          {required ChatRoomID chatRoomId,
          required int pageSize,
          DocumentSnapshot? docSnapshot}) =>
      _service.paginatedCollectionStream(
          path: DBPath.chats(chatRoomId),
          builder: (data) => Chat.fromMap(data),
          queryBuilder: (query) =>
              _paginatedQuery(query!, pageSize, docSnapshot));

  Query _paginatedQuery(
      Query query, int pageSize, DocumentSnapshot? docSnapshot) {
    final initialQuery = query.orderBy('id', descending: true).limit(pageSize);

    return docSnapshot != null
        ? initialQuery.startAfterDocument(docSnapshot)
        : initialQuery;
  }
}

@Riverpod(keepAlive: true)
ChatRepository chatRepository(ChatRepositoryRef ref) =>
    ChatRepository(service: ref.watch(firestoreServiceProvider));

@riverpod
Stream<List<Chat>> chatsStream(ChatsStreamRef ref, ChatRoomID chatRoomId) =>
    ref.watch(chatRepositoryProvider).watchChats(chatRoomId);

@riverpod
Stream<(List<Chat>, DocumentSnapshot?)> paginatedChatsStream(
    PaginatedChatsStreamRef ref,
    ChatRoomID chatRoomId,
    int pageSize,
    DocumentSnapshot? documentSnapshot) {
  return ref.watch(chatRepositoryProvider).watchPaginatedChats(
      chatRoomId: chatRoomId,
      pageSize: pageSize,
      docSnapshot: documentSnapshot);
}

final chatsQueryProvider = StateProvider.autoDispose
    .family<Query<Chat>, ChatRoomID>((ref, chatRoomId) =>
        ref.watch(chatRepositoryProvider).chatsQuery(chatRoomId));
