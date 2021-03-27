import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utils/src/provider_event.dart';
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
    content: DefaultTextStyle.merge(
      style: TextStyle(color: ThemeExtension.of(context).onSuccessColor),
      child: content
    ),
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
    content: DefaultTextStyle.merge(
      style: TextStyle(color: ThemeExtension.of(context).onErrorColor),
      child: content
    ),
  ));
}



void showEventSnackbar(BuildContext context, ProviderEvent<Event> providerEvent, {Widget? success, Widget? error}) {
  if (providerEvent.hasEvent) {
    final Event? event = providerEvent.consumeEvent();
    if (event?.type == EventType.success) {
      showSuccessSnackbar(context: context, content: success??Text('Success'));
    } else if (event?.type == EventType.error) {
      showErrorSnackbar(context: context, content: error??Text('${event?.error}'));
    }
  }
}