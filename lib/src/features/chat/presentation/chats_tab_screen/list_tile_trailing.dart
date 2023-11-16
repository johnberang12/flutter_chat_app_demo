import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../constants/sizes.dart';
import '../../../../constants/styles.dart';
import '../../sub_features/delete_chat_room/time_left_widget.dart';
import 'chat_room_list_tile.dart';

class ListTileTrailing extends ConsumerWidget {
  const ListTileTrailing(
      {super.key, required this.deleteChatRoom, required this.undoDeletion});

  final Future<void> Function(WidgetRef) deleteChatRoom;
  final Future<void> Function(WidgetRef) undoDeletion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(chatRoomProvider);
    final deletedAt = room.deletedAt;
    return deletedAt != null
        ? _UndoButton(undoDeletion: undoDeletion, deletedAt: deletedAt)
        : _DeleteOptionWidget(deleteChatRoom: deleteChatRoom);
  }
}

class _UndoButton extends ConsumerWidget {
  const _UndoButton({required this.undoDeletion, required this.deletedAt});
  final DateTime deletedAt;
  final Future<void> Function(WidgetRef) undoDeletion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => undoDeletion(ref),
          child: Text(
            'Undo',
            style: Styles.k16Bold(context).copyWith(color: Colors.purple),
          ),
        ),
        Expanded(child: TimeLeftWidget(deletedAt: deletedAt))
      ],
    );
  }
}

class _DeleteOptionWidget extends HookConsumerWidget {
  const _DeleteOptionWidget({required this.deleteChatRoom});
  final Future<void> Function(WidgetRef) deleteChatRoom;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
        onSelected: (value) => _onSelectMenu(ref, value),
        itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      gapW8,
                      Text('Delete')
                    ],
                  )),
              const PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [Icon(Icons.cancel), gapW8, Text('Cancel')],
                  )),
            ]);
  }

  Future<void> _onSelectMenu(WidgetRef ref, int? value) async {
    if (value == null) return;
    if (value == 0) {
      await deleteChatRoom(ref);
    }
  }
}
