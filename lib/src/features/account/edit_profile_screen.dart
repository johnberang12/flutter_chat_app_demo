import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/src/common_widgets/outlined_text_field.dart';
import 'package:flutter_chat_app/src/common_widgets/primary_button.dart';
import 'package:flutter_chat_app/src/constants/sizes.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      // appBar: AppBar(
      //   title: const Text('Edit profile'),
      // ),
      navigationBar: CupertinoNavigationBar(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name'),
              OutlinedTextField(),
              gapH16,
              PrimaryButton()
            ],
          ),
        ),
      ),
    );
  }
}
