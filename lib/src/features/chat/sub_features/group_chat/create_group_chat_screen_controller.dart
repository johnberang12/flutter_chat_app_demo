import 'package:flutter_chat_app/src/features/app_router/app_router.dart';
import 'package:flutter_chat_app/src/features/chat/application/group_chat_room_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_group_chat_screen_controller.g.dart';

@riverpod
class CreateGroupChatScreenController
    extends _$CreateGroupChatScreenController {
  @override
  FutureOr<void> build() {}

  Future<void> createGroupChat(
      String chatRoomTitle, bool Function() mounted) async {
    state = const AsyncLoading();
    final newState = await AsyncValue.guard(() =>
        ref.read(groupChatRoomServiceProvider).createGroupChat(chatRoomTitle));
    if (mounted()) {
      if (!newState.hasError) {
        ref.read(goRouterProvider).pop();
      } else {
        state = newState;
      }
    }
  }
}
