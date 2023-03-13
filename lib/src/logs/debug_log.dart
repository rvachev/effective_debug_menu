enum LogType { debug, info, error, warn }

class DebugLog {
  final Object message;
  final LogType type;

  DebugLog({required this.message, required this.type});
}
