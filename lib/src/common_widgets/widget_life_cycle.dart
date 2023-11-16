import 'package:flutter/material.dart';

class WidgetLifecyle extends StatefulWidget {
  const WidgetLifecyle(
      {super.key,
      required this.child,
      this.init,
      this.resumed,
      this.inactive,
      this.pause,
      this.detached});
  final Widget child;
  final void Function()? init;
  final void Function()? resumed;
  final void Function()? inactive;
  final void Function()? pause;
  final void Function()? detached;

  @override
  State<WidgetLifecyle> createState() => _WidgetLifecyleState();
}

class _WidgetLifecyleState extends State<WidgetLifecyle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    if (widget.init != null) {
      widget.init!();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
        //   if (widget.resumed != null) widget.resumed!();
        // });

        break;
      case AppLifecycleState.inactive:
        if (widget.inactive != null) widget.inactive!();

        break;
      case AppLifecycleState.paused:
        if (widget.pause != null) widget.pause!();
        break;
      case AppLifecycleState.detached:
        if (widget.detached != null) widget.detached!();

        break;
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
