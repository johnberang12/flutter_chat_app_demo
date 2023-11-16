import 'package:flutter_chat_app/src/common_widgets/custom_list_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../users/domain/app_user.dart';

class SelectedGroupChatMembersList extends CustomListController<AppUser?> {
  SelectedGroupChatMembersList() : super(<AppUser?>[]);
}

final selectedGroupChatMembersProvider = StateNotifierProvider.autoDispose<
    SelectedGroupChatMembersList,
    List<AppUser?>>((ref) => SelectedGroupChatMembersList());
