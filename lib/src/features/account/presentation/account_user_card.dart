import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/users/data/app_user_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common_widgets/user_avatar.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';
import '../../app_router/app_router.dart';

class UserAccountCard extends ConsumerWidget {
  const UserAccountCard({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final appUser = ref.watch(appUserStreamProvider(user.uid)).value;
    return InkWell(
      onTap: () => context.pushNamed(RoutePath.editProfile.name),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: size.width * 0.20, maxHeight: size.height * 0.10),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: UserAvatar(
                      photoUrl: appUser?.photoUrl ?? user.photoURL ?? "",
                      radius: 30),
                ),
              ),
              gapW12,
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(appUser?.name ?? user.displayName ?? "Unknown User",
                        style: Styles.k16Bold(context)),
                    gapH8,
                    Text(user.uid),
                  ],
                ),
              ),
              const Icon(Icons.edit)
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton(
      {Key? key,
      this.icon,
      required this.onPressed,
      required this.buttonLabel,
      this.isLoading = false,
      this.buttonKey})
      : super(key: key);
  final Widget? icon;
  final void Function() onPressed;
  final String buttonLabel;
  final bool isLoading;
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(buttonLabel),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onPressed,
    );

    // TextButton(
    //     key: buttonKey,
    //     onPressed: isLoading ? null : onPressed,
    //     child: Row(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         if (icon != null) ...[icon!, gapW8],
    //         Text(buttonLabel)
    //       ],
    //     ));
  }
}
