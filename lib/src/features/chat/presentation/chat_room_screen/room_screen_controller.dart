import 'dart:io';

import 'package:flutter_chat_app/src/features/chat/application/chat_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../users/domain/app_user.dart';
import '../../domain/chat.dart';
import '../../domain/chat_room.dart';

part 'room_screen_controller.g.dart';

@riverpod
class RoomScreenController extends _$RoomScreenController {
  @override
  FutureOr<void> build() {}

  Future<void> sendChat(
      {required ChatRoom? chatRoom,
      required AppUser peerUser,
      required Chat chat,
      required List<File> files,
      required bool Function() mounted}) async {
    state = const AsyncLoading();
    final newState = await AsyncValue.guard(() => ref
        .read(chatServiceProvider)
        .sendChat(
            chatRoom: chatRoom, chat: chat, peerUser: peerUser, files: files));
    if (mounted()) {
      state = newState;
    }
  }
}
