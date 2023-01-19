import 'package:effective_debug_menu/src/network/logger/log_records_container.dart';
import 'package:effective_debug_menu/src/ui/drawer_gesture_detector.dart';
import 'package:effective_debug_menu/src/ui/logs_list_view.dart';
import 'package:flutter/material.dart';

class DebugPanel extends StatefulWidget {
  final Widget child;

  const DebugPanel({super.key, required this.child});

  @override
  State<DebugPanel> createState() => _DebugPanelState();
}

class _DebugPanelState extends State<DebugPanel> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                  color: Colors.white,
                  child: ElevatedButton(
                    onPressed: _showLogsDialog,
                    child: const Text('VIEW LOGS'),
                  )),
            ],
          ),
        ),
      ),
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        key: _scaffoldKey,
        child: Stack(
          children: [
            widget.child,
            Positioned(
                top: 16,
                right: 16,
                child: DrawerGestureDetector(
                  callback: _showDebugPanel,
                )),
          ],
        ),
      ),
    );
  }

  void _showLogsDialog() {
    showDialog(
        context: context,
        builder: (context) {
          final logs = LogRecordsContainer.instance.logs;
          return Dialog(
            insetPadding: const EdgeInsets.all(20.0),
            child: Container(
                color: Colors.white,
                child: LogsListView(
                  logs: logs,
                )),
          );
        });
  }

  void _showDebugPanel() {
    Scaffold.of(_scaffoldKey.currentContext!).openEndDrawer();
  }
}
