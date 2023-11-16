import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/constants/sizes.dart';
import 'package:flutter_chat_app/src/constants/styles.dart';
import 'package:flutter_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_chat_app/src/features/chat/util/get_chat_room_id.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app_router/app_router.dart';
import '../domain/app_user.dart';

class UserDetailScreen extends ConsumerWidget {
  const UserDetailScreen({super.key, required this.appUser});
  final AppUser appUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authRepositoryProvider).currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(radius: 70, child: Icon(Icons.person, size: 100)),
          gapH16,
          Text(appUser.name, style: Styles.k20Grey(context)),
          gapH12,
          Text(appUser.title),
          gapH32,
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: currentUser == null
                  ? null
                  : () => context.pushNamed(RoutePath.chatRoom.name,
                      pathParameters: {
                        'chatRoomId':
                            getChatRoomId(currentUser.uid, appUser.uid)
                      },
                      extra: appUser),
              child: Text(
                'Chat',
                style: Styles.k18Bold(context),
              ))
        ],
      )),
    );
  }
}
