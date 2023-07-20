enum LogType { debug, info, error, warn }

class DebugLog {
  final Object message;
  final LogType type;

  const DebugLog({required this.message, required this.type});
}
