import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/styles.dart';

class HomeSearchWidget extends StatelessWidget {
  const HomeSearchWidget({super.key, required this.onTap});
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: AppColors.grey500),
            borderRadius: BorderRadius.circular(24)),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.search),
                  ),
                  Expanded(
                    child: Text(
                      'Who are you looking for?',
                      style: Styles.k20(context),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 45,
              width: 80,
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(24)),
              child: const Center(
                child: Text('Search'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
