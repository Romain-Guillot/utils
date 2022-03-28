import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utils/src/provider_event.dart';
import 'package:utils/src/theme_extension.dart';

const EdgeInsets kSnakbarDefaultMargin = EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0);

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>  showSuccessSnackbar({
  required BuildContext context,
  required Widget content,
  SnackBarAction? action,
  Animation<double>? animation,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    // width: ThemeExtension.of(context).snackbarMaxSize,
    margin: kSnakbarDefaultMargin,
    behavior: SnackBarBehavior.floating,
    action: action,
    animation: animation,
    backgroundColor: ThemeExtension.of(context).successColor,
    content: DefaultTextStyle.merge(
      style: TextStyle(color: ThemeExtension.of(context).onSuccessColor),
      child: content
    ),
  ));
}


ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorSnackbar({
  required BuildContext context,
  required Widget content,
  SnackBarAction? action,
  Animation<double>? animation,
}) {
  return ScaffoldMessenger.maybeOf(context)!.showSnackBar(SnackBar(
    // width: ThemeExtension.of(context).snackbarMaxSize.isNaN ? null : ThemeExtension.of(context).snackbarMaxSize,
    margin: kSnakbarDefaultMargin,
    behavior: SnackBarBehavior.floating,
    action: action,
    animation: animation,
    backgroundColor: ThemeExtension.of(context).errorColor,
    content: DefaultTextStyle.merge(
      style: TextStyle(color: ThemeExtension.of(context).onErrorColor),
      child: content
    ),
  ));
}



// void showEventSnackbar(BuildContext context, ProviderEvent<Event> providerEvent, {Widget? success, Widget? error}) {
//   if (providerEvent.hasEvent) {
//     final Event? event = providerEvent.consumeEvent();
//     if (event?.type == EventType.success) {
//       showSuccessSnackbar(context: context, content: success??Text('Success'));
//     } else if (event?.type == EventType.error) {
//       showErrorSnackbar(context: context, content: error??Text('${event?.error}'));
//     }
//   }
// }

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showEventSnackbar(BuildContext context, {
  required ProviderEvent<Event> event,
  String? successMessage,
  String? errorMessage, 
}) {
  if (event.hasEvent) {
    final Event? eventValue = event.consumeEvent();
    if (eventValue != null) {
      switch (eventValue.type) {
        case EventType.success:
          if (successMessage != null)
            return showSuccessSnackbar(context: context, content: Text(successMessage));
          break;
        case EventType.error:
          if (errorMessage != null)
            return showErrorSnackbar(context: context, content: Text(errorMessage));
          break;
      }
    }
  }
  return null;
}