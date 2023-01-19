import 'package:effective_dio_interceptor/effective_dio_interceptor.dart';
import 'package:flutter/material.dart';

extension LogMessageTypeX on LogMessageType {
  Color get color {
    switch (this) {
      case LogMessageType.error:
        return Colors.red.withOpacity(0.3);
      case LogMessageType.request:
        return Colors.yellow.withOpacity(0.3);
      case LogMessageType.response:
        return Colors.green.withOpacity(0.3);
      default:
        return Colors.white;
    }
  }
}
