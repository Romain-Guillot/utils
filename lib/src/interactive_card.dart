import 'package:flutter/material.dart';


class InteractiveCard extends StatelessWidget {
  const InteractiveCard({
    Key? key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: child
    );
  }
}