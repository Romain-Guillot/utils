import 'package:flutter/widgets.dart';

String? nonNulValidator(BuildContext context, dynamic? value, [String? message]) => value == null ? message??'Required' : null;
String? nonEmptyValidator(BuildContext context, Iterable<dynamic>? value, [String? message]) => nonNulValidator(context, value)??(value!.isEmpty ? message??'Empty not allowed' : null);
String? nonEmptyStringValidator(BuildContext context, String? value, [String? message]) => nonNulValidator(context, value)??(value!.isEmpty ? message??'Empty not allowed' : null);