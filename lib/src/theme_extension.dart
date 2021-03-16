import 'package:flutter/material.dart';


class ThemeDataExtension {
  const ThemeDataExtension({
    required this.errorColor,
    required this.onErrorColor,
    required this.successColor,
    required this.onSuccessColor,
    required this.padding,
    required this.paddingBig,
    required this.paddingSmall,
    required this.smallBorderRadius,
    required this.mediumBorderRadius,
    required this.bigBorderRadius,
    required this.mobileScreenMax,
    required this.barrierColor,
  });

  final Color errorColor;
  final Color onErrorColor;
  final Color successColor;
  final Color onSuccessColor;
  final double padding;
  final double paddingSmall;
  final double paddingBig;
  final BorderRadius smallBorderRadius;
  final BorderRadius mediumBorderRadius;
  final BorderRadius bigBorderRadius;
  final double mobileScreenMax;
  final Color barrierColor;
}


class ThemeExtension extends InheritedWidget {
  ThemeExtension({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final ThemeDataExtension data;

 static ThemeDataExtension of(BuildContext context) {
    final ThemeExtension? result = context.dependOnInheritedWidgetOfExactType<ThemeExtension>();
    assert(result != null, 'No ThemeExtension found in context');
    return result!.data;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

}