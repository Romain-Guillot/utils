import 'package:flutter/material.dart';


class AdaptativeBuilder extends StatelessWidget {
  const AdaptativeBuilder({
    Key? key,
    this.availableWidth,
    required this.breakpoint,
    required this.wide,
    required this.narrow,
  }) : super(key: key);

  final double? availableWidth;
  final double breakpoint;
  final Widget wide;
  final Widget narrow;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if ((availableWidth??constraints.maxWidth) > breakpoint) {
          return wide;
        } else {
          return narrow;
        }
      },
    );
  }
}