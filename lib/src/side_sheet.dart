import 'package:flutter/material.dart';


Future<T?> showSideSheet<T extends Object?>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  bool rightSide = true,
}) {
  return showGeneralDialog<T>(
    barrierLabel: 'Barrier',
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 300),
    context: context,
    pageBuilder: (BuildContext context, Animation<double> animation1, Animation<double> animation2) {
      return Align(
        alignment: rightSide ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          height: double.infinity,
          width: 700,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: builder(context),
        ),
      );
    },
    transitionBuilder: (BuildContext context, Animation<double> animation1, Animation<double> animation2, Widget child) {
      return SlideTransition(
        position:
            Tween<Offset>(begin: Offset(rightSide ? 1 : -1, 0), end: Offset(0, 0))
                .animate(animation1),
        child: child,
      );
    },
  );
}