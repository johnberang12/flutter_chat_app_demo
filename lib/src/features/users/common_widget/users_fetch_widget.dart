import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/app_loader.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common_widgets/center_text.dart';
import '../../../constants/sizes.dart';
import '../domain/app_user.dart';
import '../presentation/app_user_list_tile.dart';

class UsersFetchWidget extends HookConsumerWidget {
  const UsersFetchWidget({
    super.key,
    required this.usersValue,
    this.emtpyText,
    this.tileColor,
    this.onTap,
    this.separator,
    this.isLoading = false,
    this.controller,
  });
  final AsyncValue<List<AppUser>> usersValue;
  final String? emtpyText;

  final Color? tileColor;
  final void Function(AppUser)? onTap;
  final Widget? separator;
  final bool isLoading;

  final ScrollController? controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('callling UsersFetchWidget build...');

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: _buildList(context, ref));
  }

  Widget _buildList(BuildContext context, WidgetRef ref) {
    final selectedUser = useState<AppUser?>(null);
    final users = usersValue.value ?? [];
    final isFetching = usersValue.isLoading && users.isEmpty;
    final isFetchingMore = usersValue.isLoading && users.isNotEmpty;

    return AsyncValueInitLoading(
      isInitialLoading: isFetching,
      child: users.isEmpty
          ? CenterText(text: emtpyText)
          : ListView.separated(
              controller: controller,
              shrinkWrap: true,
              itemCount: users.length + (isFetchingMore ? 1 : 0),
              separatorBuilder: (context, index) => separator ?? gapH4,
              itemBuilder: (context, index) {
                if (index == users.length) {
                  if (isFetchingMore) {
                    // Return loading indicator at the bottom
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: AppLoader.circularProgress(),
                    );
                  } else {
                    // This case should not be reached if logic is correct; adding an empty container as a safeguard
                    return Container();
                  }
                }

                final user = users[index];
                // Return your regular item Widget here
                return AppUserListTile(
                  appUser: user,
                  tileColor: tileColor,
                  onTap: onTap == null
                      ? null
                      : (user) {
                          selectedUser.value = user;
                          onTap!(user);
                        },
                  isLoading: isLoading && selectedUser.value == user,
                );
              }),
    );
  }
}

class AsyncValueInitLoading extends StatelessWidget {
  const AsyncValueInitLoading(
      {super.key, required this.isInitialLoading, required this.child});

  final bool isInitialLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return isInitialLoading ? AppLoader.circularProgress() : child;
  }
}

class EndOfListText extends StatelessWidget {
  const EndOfListText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: Text("You've reached the end!")),
    );
  }
}
