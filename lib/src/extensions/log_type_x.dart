import 'package:effective_debug_menu/src/logs/debug_log.dart';
import 'package:flutter/material.dart';

extension LogTypeX on LogType {
  Color get color {
    switch (this) {
      case LogType.debug:
        return Colors.blue.withOpacity(0.3);
      case LogType.info:
        return Colors.yellow.withOpacity(0.3);
      case LogType.error:
        return Colors.red.withOpacity(0.3);
      case LogType.warn:
        return Colors.orange.withOpacity(0.3);
    }
  }
}
