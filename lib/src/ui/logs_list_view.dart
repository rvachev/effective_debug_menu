import 'package:effective_debug_menu/src/extensions/log_message_type_x.dart';
import 'package:effective_dio_interceptor/effective_dio_interceptor.dart';
import 'package:flutter/material.dart';

class LogsListView extends StatelessWidget {
  final List<LogMessage> logs;

  const LogsListView({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      reverse: true,
      itemCount: logs.length,
      itemBuilder: (context, i) {
        return _LogItem(log: logs[i]);
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }
}

class _LogItem extends StatelessWidget {
  final LogMessage log;

  const _LogItem({required this.log});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: log.type.color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(log.toString()),
      ),
    );
  }
}
