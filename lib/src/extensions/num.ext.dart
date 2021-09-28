import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension NumFormat on num {
  String format(BuildContext context) {
    final NumberFormat numberFormatter = NumberFormat(null, Localizations.localeOf(context).languageCode);
    return numberFormatter.format(this);
  }
}