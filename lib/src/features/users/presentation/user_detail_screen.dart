import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/constants/sizes.dart';
import 'package:flutter_chat_app/src/constants/styles.dart';
import 'package:go_router/go_router.dart';

import '../../app_router/app_router.dart';
import '../domain/app_user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.appUser});
  final AppUser appUser;

  @override
  Widget build(BuildContext context) {
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
              onPressed: () =>
                  context.pushNamed(RoutePath.chatRoom.name, extra: appUser),
              child: Text(
                'Chat',
                style: Styles.k18Bold(context),
              ))
        ],
      )),
    );
  }
}
