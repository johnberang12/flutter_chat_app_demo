import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/center_text.dart';
import 'package:flutter_chat_app/src/features/search/application/search_service.dart';
import 'package:flutter_chat_app/src/features/search/presentation/user_search_controller.dart';
import 'package:flutter_chat_app/src/utils/async_value_error.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen2 extends ConsumerStatefulWidget {
  const HomeScreen2({super.key});

  @override
  ConsumerState<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends ConsumerState<HomeScreen2> {
  final _queryController = TextEditingController();
  String get searchQuery => _queryController.text;

  final applicationId = dotenv.env['ALGOLIA_APPLICATION_ID'] ?? "";
  final apiKey = dotenv.env['ALGOLIA_API_KEY'] ?? "";

  @override
  Widget build(BuildContext context) {
    ref.listen(userSearchControllerProvider,
        (previous, next) => next.showAlertDialogOnError(context));
    final state = ref.watch(userSearchControllerProvider);
    final usersValue = ref.watch(searchedUsersProvider);
    return Scaffold(
      appBar: AppBar(
          title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Expanded(child: TextFormField(controller: _queryController)),
            IconButton(
                onPressed: () => ref
                    .read(userSearchControllerProvider.notifier)
                    .fetchSearchedUsers(searchQuery),
                icon: const Icon(Icons.search))
          ],
        ),
      )),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : usersValue.when(
              data: (users) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final item = users[index];
                      return ListTile(
                        title: Text(item?.name ?? 'No Name'),
                      );
                    });
              },
              error: (e, st) => CenterText(
                    text: e.toString(),
                  ),
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive())),
    );
  }
}
