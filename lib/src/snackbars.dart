import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utils/src/theme_extension.dart';


void showSuccessSnackbar({
  required BuildContext context,
  required Widget content,
  SnackBarAction? action,
  Animation<double>? animation,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    action: action,
    animation: animation,
    backgroundColor: ThemeExtension.of(context).successColor,
    content: content,
  ));
}


void showErrorSnackbar({
  required BuildContext context,
  required Widget content,
  SnackBarAction? action,
  Animation<double>? animation,
}) {
  ScaffoldMessenger.maybeOf(context)!.showSnackBar(SnackBar(
    action: action,
    animation: animation,
    backgroundColor: ThemeExtension.of(context).errorColor,
    content: content,
  ));
}