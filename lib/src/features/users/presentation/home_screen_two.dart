import 'package:async_widget/async_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter_chat_app/src/common_widgets/primary_button.dart';
import 'package:flutter_chat_app/src/constants/sizes.dart';
import 'package:flutter_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_chat_app/src/services/firestore/firestore_service.dart';
import 'package:flutter_chat_app/src/utils/async_value_error.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen2 extends StatefulHookConsumerWidget {
  const HomeScreen2({super.key});

  @override
  ConsumerState<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends ConsumerState<HomeScreen2> {
  final _queryController = TextEditingController();
  String get searchQuery => _queryController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(child: TextFormField(controller: _queryController)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.search))
            ],
          ),
        )),
        body: Center(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              gapH64,
              AsyncWidget<dynamic>(
                identifier: idFromCurrentDate(),
                listener: (_, next) {
                  ///handle error here
                  next.showAlertDialogOnError(context);
                },
                callback: (param) async {
                  await ref.read(authRepositoryProvider).signOut();
                },
                child: (state, execute) => PrimaryButton(
                  buttonTitle: 'Log out',
                  onPressed: () => execute(null),
                  loading: state.isLoading,
                ),
              ),
              gapH64,
              AsyncWidget<dynamic>(
                identifier: idFromCurrentDate(),
                listener: (_, next) => next.showAlertDialogOnError(context),
                callback: (param) async {
                  await ref.read(authRepositoryProvider).deleteAccount();
                },
                child: (state, execute) => PrimaryButton(
                  buttonTitle: 'Delete account',
                  onPressed: () => execute(null),
                  //  () {
                  //   // ref.read(asynchronousControllerProvider.notifier).execute(
                  //   //     () => ref.read(authRepositoryProvider).deleteAccount());
                  // },
                  loading: state.isLoading,
                ),
              )
            ],
          ),
        ));
  }
}
