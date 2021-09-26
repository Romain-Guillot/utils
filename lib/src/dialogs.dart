import 'dart:async';

import 'package:flutter/material.dart';
import 'package:utils/src/theme_extension.dart';

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required Widget title,
  Widget? content,
  required Widget okLabel,
  required Widget nokLabel,
}) async {
  bool? confirmation =  await showDialog<bool>(context: context, builder: (context) => AlertDialog(
    title: title,
    content: content,
    actions: <Widget>[
      TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error,
          primary: Theme.of(context).colorScheme.onError
        ),
        onPressed: () {
          Navigator.pop(context, false);
        }, 
        icon: Icon(Icons.cancel_outlined), 
        label: nokLabel
      ),
      TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: ThemeExtension.of(context).successColor,
          primary: ThemeExtension.of(context).onSuccessColor
        ),
        onPressed: () {
          Navigator.pop(context, true);
        }, 
        icon: Icon(Icons.check_circle_outline), 
        label: okLabel
      ),
    ],
  ));
  return confirmation??false;
}