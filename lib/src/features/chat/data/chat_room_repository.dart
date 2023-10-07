// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_chat_app/src/services/firestore/db_path.dart';
import 'package:flutter_chat_app/src/services/firestore/firestore_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../users/domain/app_user.dart';
import '../domain/chat_room.dart';
part 'chat_room_repository.g.dart';

class ChatRoomRepository {
  ChatRoomRepository({
    required FirestoreService service,
  }) : _service = service;
  final FirestoreService _service;

  Future<void> createChatRoom(ChatRoom chatRoom) => _service.setData(
      path: DBPath.chatRoom(chatRoom.id), data: chatRoom.toMap());

  Future<void> updateChatRoom(ChatRoomID roomId, Map<String, dynamic> data) =>
      _service.updateDoc(path: DBPath.chatRoom(roomId), data: data);

  Future<void> deleteChatRoom(ChatRoomID id) =>
      _service.deleteData(path: DBPath.chatRoom(id));

  Stream<ChatRoom?> watchChatRoom(ChatRoomID chatRoomId) =>
      _service.documentStream(
          path: DBPath.chatRoom(chatRoomId),
          builder: (data) => ChatRoom.fromMap(data));

  Stream<List<ChatRoom?>> watchChatRooms(UserID userId) =>
      _service.collectionStream(
        path: DBPath.chatRooms(),
        builder: (data) => ChatRoom.fromMap(data),
        queryBuilder: (query) =>
            query!.where('memberIds', arrayContains: userId),
      );
}

@Riverpod(keepAlive: true)
ChatRoomRepository chatRoomRepository(ChatRoomRepositoryRef ref) =>
    ChatRoomRepository(service: ref.watch(firestoreServiceProvider));



// final chatRoomRepositoryProvider = Provider<ChatRoomRepository>(
//     (ref) => ChatRoomRepository(service: ref.watch(firestoreServiceProvider)));

// final chatRoomsStreamProvider = StreamProvider.autoDispose<List<ChatRoom?>>(
//     (ref) => ref.watch(chatRoomRepositoryProvider).watchChatRooms());

