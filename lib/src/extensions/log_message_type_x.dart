import 'package:effective_debug_menu/src/logs/debug_log.dart';
import 'package:effective_dio_interceptor/effective_dio_interceptor.dart';

extension LogMessageTypeX on LogMessageType {
  LogType toLogType() {
    switch (this) {
      case LogMessageType.error:
        return LogType.error;
      case LogMessageType.request:
        return LogType.info;
      case LogMessageType.response:
        return LogType.debug;
    }
  }
}
