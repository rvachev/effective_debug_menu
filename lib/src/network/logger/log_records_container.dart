import 'package:effective_dio_interceptor/effective_dio_interceptor.dart';

class LogRecordsContainer {
  static LogRecordsContainer? _instance;

  static LogRecordsContainer get instance =>
      _instance ??= LogRecordsContainer._();

  LogRecordsContainer._();

  final List<LogMessage> _logs = [];

  List<LogMessage> get logs => _logs.reversed.toList();

  void addLogMessage(LogMessage log) {
    _logs.add(log);
  }
}
