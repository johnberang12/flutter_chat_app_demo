import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

import '../../../../../constants/styles.dart';

class ChatBadge extends StatelessWidget {
  const ChatBadge({super.key, required this.badgeCount});
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      badgeContent: Text(badgeCount.toString(),
          style: Styles.k10(context).copyWith(color: Colors.white)),
    );
  }
}
