import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common_widgets/async_value_when.dart';
import '../../../common_widgets/center_text.dart';
import '../../../constants/sizes.dart';
import '../domain/app_user.dart';
import '../presentation/app_user_list_tile.dart';

class UsersFetchWidget extends ConsumerWidget {
  const UsersFetchWidget({super.key, required this.usersValue, this.emtpyText});
  final String? emtpyText;
  final AsyncValue<List<AppUser?>> usersValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: AsyncValueWhen<List<AppUser?>>(
          value: usersValue,
          data: (users) => users.isEmpty
              ? CenterText(text: emtpyText)
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: users.length,
                  separatorBuilder: (context, index) => gapH12,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return user != null
                        ? AppUserListTile(appUser: user)
                        : const SizedBox();
                  })),
    );
  }
}
