import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';


class AppLogger {
  static Logger logger = Logger();
  // static FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  static void wrap(Function runApp) {
    // FlutterError.onError = crashlytics.recordFlutterError;
    // runZonedGuarded<Future<void>>(() async {
    //   runApp();
    // }, crashlytics.recordError);
  }

  static void d(String namespace, String message, [dynamic? error, StackTrace? stacktrace]) {
    logger.d('$namespace > $message', error, stacktrace);
    // crashlytics.log('$namespace > $message ; $e');
  }


  static void e(String namespace, String message, [dynamic? error, StackTrace? stacktrace]) {
    logger.e('$namespace > $message', error, stacktrace);
    // crashlytics.recordError(error, stacktrace, reason: '$namespace > $message');
  }


  static void w(String namespace, String message, [dynamic? error, StackTrace? stacktrace]) {
    logger.w('$namespace > $message', error, stacktrace);
    // crashlytics.log('$namespace > $message ; $e');
  }

  static void test() {
    logger.e('test error');
    // crashlytics.crash();
  }
}