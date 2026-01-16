import 'package:flutter/material.dart';

class LogService {
  static void log(Object message) {
    debugPrint(message.toString());
  }

  static void logMap(Map<dynamic, dynamic> map) {
    debugPrint('\n');
    debugPrint('--------------------------------');
    debugPrint('{');
    map.forEach((key, value) {
      debugPrint('  $key: $value');
    });
    debugPrint('}');
    debugPrint('--------------------------------');
    debugPrint('\n');
  }
}
