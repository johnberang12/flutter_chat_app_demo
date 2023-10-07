import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/constants/sizes.dart';
import 'package:flutter_chat_app/src/features/app_router/app_router.dart';
import 'package:flutter_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/styles.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Screen'),
        actions: [
          IconButton(
              onPressed: () => context.pushNamed(RoutePath.settings.name),
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 70,
            child: Icon(Icons.person, size: 100),
          ),
          gapH16,
          Text(user?.displayName ?? 'My Name'),
          gapH8,
          Text(user?.uid ?? 'uid'),
          gapH24,
          ElevatedButton(
              onPressed: () => context.pushNamed(RoutePath.editProfile.name),
              child: Text(
                'Edit Profile',
                style: Styles.k18Bold(context),
              ))
        ],
      )),
    );
  }
}
