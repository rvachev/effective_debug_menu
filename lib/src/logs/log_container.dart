import 'package:effective_debug_menu/src/logs/debug_log.dart';

class DebugMenuLogContainer {
  static final List<DebugLog> _messages = [];

  static List<DebugLog> get messages => _messages;

  static void add(DebugLog log) {
    _messages.add(log);
  }
}
