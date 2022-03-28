import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Vérifie si le state est bien dans l'arbre de widget avant d'appeller la fonction [setState]
abstract class SafeState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}


abstract class ConsumerSafeState<T extends ConsumerStatefulWidget> extends ConsumerState<T> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}