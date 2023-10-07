import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/app_loader.dart';
import 'package:flutter_chat_app/src/features/app_router/app_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';
import '../domain/app_user.dart';
import '../home_screen_controller.dart';

class AppUserListTile extends HookConsumerWidget {
  const AppUserListTile({
    super.key,
    required this.appUser,
  });
  final AppUser appUser;

  Future<void> onUpdateUserName(AppUser appUser, WidgetRef ref) async {
    //*update user name

    final faker = Faker();
    final name = faker.person.name();
    final newAppUser = appUser.copyWith(name: name);
    await ref
        .read(homeScreenControllerProvider.notifier)
        .createAppUser(newAppUser);
  }

  Future<void> onDeleteAppUser(AppUser appUser, WidgetRef ref) async {
    //*delete appUser here
    await ref
        .read(homeScreenControllerProvider.notifier)
        .deleteUser(appUser.uid);
  }

  // Future<void> _onSelectMenu(BuildContext context, WidgetRef ref, int? value,
  //     ValueNotifier<AppUser?> selectedUser) async {
  //   selectedUser.value = appUser;
  //   if (value == null) return;
  //   if (value == 0) {
  //     await onUpdateUserName(appUser, ref);
  //   } else if (value == 1) {
  //     await _deleteConfirmation(context, ref, appUser);
  //   }
  //   selectedUser.value = null;
  // }

  // Future<void> _deleteConfirmation(
  //         BuildContext context, WidgetRef ref, AppUser appUser) =>
  //     showConfirmationDialog(
  //         context: context,
  //         cancelActionText: 'Cancel',
  //         defaultActionText: 'Delete',
  //         content: 'Are you sure you want to delete this user?',
  //         onConfirm: () => onDeleteAppUser(appUser, ref));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final randomInt = useState<int>(0);
    final selectedUser = useState<AppUser?>(null);
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        randomInt.value = Random().nextInt(3);
      });

      return null;
    });
    final state = ref.watch(homeScreenControllerProvider);
    return GestureDetector(
      onTap: () =>
          context.pushNamed(RoutePath.userDetails.name, extra: appUser),
      // onLongPress: () {},
      child: ListTile(
        tileColor: Colors.blueGrey.shade600,
        // colors[randomInt.value],
        leading:
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 48)),
        title: state.isLoading && selectedUser.value == appUser
            ? AppLoader.circularProgress()
            : Text(
                appUser.name,
                style: Styles.k18Bold(context).copyWith(color: Colors.white),
              ),
        subtitle: Text(appUser.title,
            style: Styles.k14(context).copyWith(color: Colors.white)),
      ),
    );

    // PopupMenuButton<int>(
    //   onSelected: (value) => _onSelectMenu(context, ref, value, selectedUser),
    //   itemBuilder: menuItems,
    //   child: ,
    // );
  }

  List<PopupMenuEntry<int>> menuItems(BuildContext context) =>
      <PopupMenuEntry<int>>[
        const PopupMenuItem(
            value: 0,
            child: Row(
              children: [Icon(Icons.edit), gapW8, Text('Update Name')],
            )),
        const PopupMenuItem(
            value: 1,
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.red),
                gapW8,
                Text('Delete')
              ],
            )),
      ];
}

Map<int, Color> colors = {0: Colors.amber, 1: Colors.blue, 2: Colors.blueGrey};
