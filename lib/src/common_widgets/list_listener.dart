import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ListListener<T> extends HookWidget {
  ///A widget that fires a call back when there is a changes on the list
  ///
  const ListListener(
      {super.key,
      required this.chats,
      required this.callback,
      required this.child});
  final List<T> chats;
  final Function() callback;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      callback();
      return null;
    }, [chats]);
    return child;
  }
}
