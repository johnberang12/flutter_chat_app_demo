import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/chat/presentation/chats_tab_screen/room_list_tile_base.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common_widgets/alert_dialogs.dart';
import '../../../users/domain/app_user.dart';
import '../../domain/chat_room.dart';
import '../../sub_features/delete_chat_room/delete_chat_room_controller.dart';

class ChatRoomListTile extends HookConsumerWidget {
  const ChatRoomListTile({super.key});

  Future<void> _deleteChatRoom(WidgetRef ref) async {
    ///delete operation here
    final room = ref.read(chatRoomProvider);
    await ref
        .read(deleteChatRoomControllerProvider.notifier)
        .deleteChatRoom(room);
  }

  Future<void> _undoDeletion(WidgetRef ref) async {
    ///undo deleted conversation here
    final room = ref.read(chatRoomProvider);
    await ref
        .read(deleteChatRoomControllerProvider.notifier)
        .undoDeletion(room.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRoomId = useState<UserID?>(null);
    final room = ref.watch(chatRoomProvider);
    final state = ref.watch(deleteChatRoomControllerProvider);
    return room.isGroup
        ? GroupChatListTile(
            isLoading: selectedRoomId.value == room.id && state.isLoading,
            chatRoom: room,
            deleteChatRoom: (ref) =>
                _confirmDeletion(context, ref, selectedRoomId),
            undoDeletion: _undoDeletion)
        : PrivateRoomListTile(
            isLoading: selectedRoomId.value == room.id && state.isLoading,
            chatRoom: room,
            deleteChatRoom: (ref) =>
                _confirmDeletion(context, ref, selectedRoomId),
            undoDeletion: _undoDeletion);
  }

  Future<void> _assignRoomId(
      WidgetRef ref,
      ValueNotifier<UserID?> selectedRoomId,
      Future<void> Function(WidgetRef) action) async {
    final room = ref.read(chatRoomProvider);
    selectedRoomId.value = room.id;
    await action(ref);
    // selectedPeerId.value = null;
  }

  Future<void> _confirmDeletion(BuildContext context, WidgetRef ref,
          ValueNotifier<UserID?> selectedRoomId) async =>
      showConfirmationDialog(
          context: context,
          defaultActionText: "Delete",
          cancelActionText: 'Cancel',
          title: 'Confirm deletion',
          content: 'Are you sure you want to delete this entire conversation?',
          onConfirm: () => _assignRoomId(ref, selectedRoomId, _deleteChatRoom));
}

final chatRoomProvider =
    Provider<ChatRoom>((ref) => throw UnimplementedError());
