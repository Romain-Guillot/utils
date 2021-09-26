import 'package:flutter/material.dart';
import 'package:utils/src/theme_extension.dart';

class MainContainer extends StatelessWidget {
  const MainContainer({
    Key? key,
    required this.child
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(maxWidth: ThemeExtension.of(context).maxPageWidth),
        child: child
      ),
    );
  }
}