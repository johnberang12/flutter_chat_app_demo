import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/error_message_widget.dart';
import 'package:flutter_chat_app/src/constants/sizes.dart';
import 'package:flutter_chat_app/src/features/app_router/app_router.dart';
import 'package:flutter_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_chat_app/src/features/language/language_popup_menu.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'account_user_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    if (user == null) {
      return const ErrorMessageWidget(
        errorMessage: 'Somethin went wrong',
        onPressed: null,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'
            // AppLocalizations.of(context)!.helloName(user.displayName ?? "")
            ),
        actions: const [LanguagePopupMenu(), gapW8],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            UserAccountCard(user: user),
            const Spacer(),
            SettingsButton(
                icon: const Icon(Icons.settings),
                onPressed: () => context.pushNamed(RoutePath.settings.name),
                buttonLabel: AppLocalizations.of(context)!.settings),
            SettingsButton(
                icon: const Icon(Icons.mail),
                onPressed: () {},
                buttonLabel: AppLocalizations.of(context)!.inviteFriends),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
