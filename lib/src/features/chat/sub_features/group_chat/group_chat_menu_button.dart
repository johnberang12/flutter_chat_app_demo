import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/sizes.dart';
import '../../../app_router/app_router.dart';
import '../../../users/domain/app_user.dart';
import '../../domain/chat_room.dart';
import 'group_chat_screen.dart';

enum GroupChatPopupMenuItem {
  addMember(title: 'Add Member', icon: Icons.group_add),
  viewMembers(title: 'viewMembers', icon: Icons.remove_red_eye_sharp);

  const GroupChatPopupMenuItem({required this.title, required this.icon});
  final String title;
  final IconData icon;
}

class GroupChatPopupMenu extends StatelessWidget {
  const GroupChatPopupMenu(
      {super.key, required this.chatRoom, required this.userId});
  final ChatRoom chatRoom;
  //uid of current log in user
  final UserID? userId;

  @override
  Widget build(BuildContext context) {
    final userChatData = chatRoom.members.members[userId];
    final isAdmin = userChatData != null && userChatData.isAdmin;
    return PopupMenuButton<GroupChatPopupMenuItem>(
      onSelected: (value) => _onSelectMenu(context, chatRoom, value),
      itemBuilder: (context) => GroupChatPopupMenuItem.values
          .where((item) =>
              isAdmin ||
              item !=
                  GroupChatPopupMenuItem
                      .addMember) // This will filter out addMember if isAdmin is false
          .map((item) => PopupMenuItem(
                value: item,
                child: Row(
                  children: [Icon(item.icon), gapW8, Text(item.title)],
                ),
              ))
          .toList(),
    );
  }

  Future<void> _onSelectMenu(BuildContext context, ChatRoom? chatRoom,
      GroupChatPopupMenuItem? item) async {
    if (chatRoom == null || item == null) return;

    if (item == GroupChatPopupMenuItem.addMember) {
      showModalBottomSheet(
          isScrollControlled: true,
          isDismissible: true,
          useRootNavigator: true,
          context: context,
          backgroundColor: AppColors.containerColor(context),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.8,
              maxChildSize: 0.8,
              minChildSize: 0.5,
              expand: false,
              builder: (_, controller) {
                return AppUserList(chatRoom: chatRoom);
              }));
    }
    if (item == GroupChatPopupMenuItem.viewMembers) {
      context.pushNamed(RoutePath.chatMembersScreen.name, extra: chatRoom);
    }
  }
}
