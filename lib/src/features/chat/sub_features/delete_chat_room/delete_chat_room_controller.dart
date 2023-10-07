import 'package:flutter_chat_app/src/features/chat/sub_features/delete_chat_room/application/delete_chat_room_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/chat_room.dart';
part 'delete_chat_room_controller.g.dart';

@riverpod
class DeleteChatRoomController extends _$DeleteChatRoomController {
  @override
  FutureOr<void> build() {}

  Future<void> deleteChatRoom(ChatRoom chatRoom) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(deleteChatRoomServiceProvider).deleteChatRoom(chatRoom));
  }

  Future<void> undoDeletion(ChatRoomID roomId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(deleteChatRoomServiceProvider).undoDeletion(roomId));
  }
}
