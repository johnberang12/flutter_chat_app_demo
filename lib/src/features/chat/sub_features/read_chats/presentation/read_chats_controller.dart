import 'package:flutter_chat_app/src/features/chat/sub_features/read_chats/application/read_chats_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/chat_room.dart';

class ReadChatsController extends StateNotifier<AsyncValue<void>> {
  ReadChatsController({required this.chatRoom, required this.service})
      : super(const AsyncData(null)) {
    _readChats();
  }
  final ChatRoom? chatRoom;
  final ReadChatsService service;

  Future<void> _readChats() async {
    state = const AsyncLoading();
    final newState = await AsyncValue.guard(() => service.readChats(chatRoom));
    if (mounted) {
      state = newState;
    }
  }
}

final readChatsControllerProvider = StateNotifierProvider.autoDispose
    .family<ReadChatsController, AsyncValue<void>, ChatRoom?>((ref, chatRoom) =>
        ReadChatsController(
            chatRoom: chatRoom, service: ref.watch(readChatsServiceProvider)));
