import 'package:effective_debug_menu/src/network/logger/log_records_container.dart';
import 'package:effective_dio_interceptor/effective_dio_interceptor.dart';

class DebugPanelLogger implements ILogger {
  final LogRecordsContainer logsContainer = LogRecordsContainer.instance;

  @override
  void onError(LogMessage message) {
    logsContainer.addLogMessage(message);
  }

  @override
  void onRequest(LogMessage message) {
    logsContainer.addLogMessage(message);
  }

  @override
  void onResponse(LogMessage message) {
    logsContainer.addLogMessage(message);
  }
}
