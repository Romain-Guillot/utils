import 'package:flutter/material.dart';


class KeyboardVisibilityBuilder extends StatefulWidget {
  const KeyboardVisibilityBuilder({
    Key? key,
    this.child,
    required this.builder,
  }) : super(key: key);

  final Widget? child;
  final Widget Function(BuildContext context, Widget? child, bool isKeyboardVisible) builder;

  @override
  _KeyboardVisibilityBuilderState createState() => _KeyboardVisibilityBuilderState();
}

class _KeyboardVisibilityBuilderState extends State<KeyboardVisibilityBuilder>
    with WidgetsBindingObserver {
  var _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance?.window.viewInsets.bottom??0;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, widget.child, _isKeyboardVisible,);
}


class KeyboardVisibilityAdaptative extends StatelessWidget {
  const KeyboardVisibilityAdaptative({
    Key? key,
    required this.chidlIfVisible,
    required this.childIfHide,
  }) : super(key: key);

  final Widget childIfHide;
  final Widget chidlIfVisible;

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) => isKeyboardVisible ? chidlIfVisible : childIfHide,
    );
  }
}