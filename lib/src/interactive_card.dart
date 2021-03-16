import 'package:flutter/material.dart';
import 'package:utils/src/theme_extension.dart';


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
    return Material(
      borderRadius: borderRadius??ThemeExtension.of(context).mediumBorderRadius,
      color: Theme.of(context).primaryColorDark,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: borderRadius??ThemeExtension.of(context).mediumBorderRadius,
        child: child
      ),
    );
  }
}