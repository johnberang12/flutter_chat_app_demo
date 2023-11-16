import 'package:async_widget/async_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/async_value_when.dart';
import 'package:flutter_chat_app/src/common_widgets/primary_button.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/group_chat/selected_group_chat_members_list.dart';
import 'package:flutter_chat_app/src/services/firestore/firestore_service.dart';
import 'package:flutter_chat_app/src/utils/async_value_error.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common_widgets/outlined_text_field.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/sizes.dart';
import '../../../search/application/search_service.dart';
import '../../../users/domain/app_user.dart';
import '../../application/group_chat_room_service.dart';

class CreateGroupChatScreen extends HookConsumerWidget {
  const CreateGroupChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController(text: '');
    final memberController = useTextEditingController(text: '');

    // final state = ref.watch(createGroupChatScreenControllerProvider);
    return Scaffold(
        appBar: AppBar(title: const Text('Create Group Chat')),
        body: AsyncWidget<dynamic>(
          listener: (_, next) => next.showAlertDialogOnError(context),
          callback: (param) => ref
              .read(groupChatRoomServiceProvider)
              .createGroupChat(titleController.text),
          identifier: idFromCurrentDate(),
          child: (state, excute) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              reverse: true,
              shrinkWrap: true,
              children: [
                gapH64,
                const Text('Group Chat Name'),
                gapH12,
                OutlinedTextField(
                  controller: titleController,
                ),
                gapH64,
                const Text('Members'),
                gapH12,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedTextField(
                      labelText: 'Search user',
                      controller: memberController,
                      onChange: (userName) => searchUser(ref, userName),
                    ),
                    SelectedMembersList(
                      membersController: memberController,
                    )
                  ],
                ),
                gapH64,
                gapH64,
                PrimaryButton(
                    loading: state.isLoading, onPressed: () => excute(null))
              ].reversed.toList(),
            ),
          ),
        ));
  }

  void searchUser(WidgetRef ref, String name) {
//search user
    ref.read(searchServiceProvider).fetchSearchResults(name);
  }
}

class SelectedMembersList extends ConsumerWidget {
  const SelectedMembersList({super.key, required this.membersController});
  final TextEditingController membersController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersValue = ref.watch(searchedStreamUsersProvider);
    final selectedMembers = ref.watch(selectedGroupChatMembersProvider);
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: ListView(
            shrinkWrap: true,
            children: [
              for (var member in selectedMembers)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                        color: AppColors.grey300,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(member?.name ?? ""),
                          gapW8,
                          InkWell(
                              onTap: () {
                                ref
                                    .read(selectedGroupChatMembersProvider
                                        .notifier)
                                    .removeItem(member);
                              },
                              child: const Icon(Icons.close))
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
        AsyncValueWhen<List<AppUser?>>(
          value: usersValue,
          data: (users) => users.isEmpty || membersController.text.isEmpty
              ? const SizedBox()
              : Card(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          leading: const CircleAvatar(
                              radius: 20, child: Icon(Icons.person, size: 28)),
                          title: Text(user!.name),
                          onTap: () {
                            ref
                                .read(selectedGroupChatMembersProvider.notifier)
                                .addItem(user);
                            membersController.clear();
                            ref.invalidate(searchedUsersProvider);
                          },
                          trailing: const CircleAvatar(
                            radius: 15,
                            child: Icon(Icons.add),
                          ),
                        );
                      }),
                ),
        ),
      ],
    );
  }
}
