import 'package:effective_debug_menu/src/extensions/log_message_type_x.dart';
import 'package:effective_debug_menu/src/logs/log_container.dart';
import 'package:effective_debug_menu/src/network/environment/ui/environment_dropdown.dart';
import 'package:effective_debug_menu/src/network/environment/ui/restart_app_snackbar.dart';
import 'package:effective_debug_menu/src/network/logger/log_records_container.dart';
import 'package:effective_debug_menu/src/ui/drawer_gesture_detector.dart';
import 'package:effective_debug_menu/src/ui/logs_list_view.dart';
import 'package:effective_dio_interceptor/effective_dio_interceptor.dart';
import 'package:flutter/material.dart';

import 'logs/debug_log.dart';
import 'network/environment/models/environment_item.dart';

class DebugPanel extends StatefulWidget {
  /// Selected [EnvironmentItem] which is used for displaying current item in dropdown
  final EnvironmentItem? selectedEnvironment;

  /// List of [EnvironmentItem] which is used for displaying whole list of possible items
  /// if is empty dropdown won't be displayed
  final List<EnvironmentItem> environments;

  /// Callback which called when new [EnvironmentItem] selected
  final void Function(EnvironmentItem item)? onEnvironmentChanged;

  /// A widget which displayed below [EnvironmentDropdown] and "View logs" button
  final Widget? additionalItem;

  /// child (usually whole app) to place debug panel on the screen
  final Widget child;

  const DebugPanel(
      {super.key,
      this.selectedEnvironment,
      this.environments = const [],
      this.onEnvironmentChanged,
      this.additionalItem,
      required this.child});

  @override
  State<DebugPanel> createState() => _DebugPanelState();
}

class _DebugPanelState extends State<DebugPanel> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) {
            return Scaffold(
              endDrawer: Drawer(
                child: SafeArea(
                  child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (widget.selectedEnvironment != null &&
                              widget.environments.isNotEmpty)
                            EnvironmentDropdown(
                              selectedEnvironment: widget.selectedEnvironment!,
                              items: widget.environments,
                              onEnvironmentChanged: (environment) {
                                if (environment == widget.selectedEnvironment) {
                                  return;
                                }
                                if (widget.onEnvironmentChanged != null) {
                                  widget.onEnvironmentChanged!(environment);
                                  ScaffoldMessenger.of(
                                          _scaffoldKey.currentContext!)
                                      .showSnackBar(const RestartAppSnackBar());
                                  Scaffold.of(_scaffoldKey.currentContext!)
                                      .closeEndDrawer();
                                }
                              },
                            ),
                          ElevatedButton(
                            onPressed: _showLogsDialog,
                            child: const Text('VIEW LOGS'),
                          ),
                          if (widget.additionalItem != null) ...[
                            const Divider(),
                            widget.additionalItem!
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              endDrawerEnableOpenDragGesture: false,
              body: Stack(
                key: _scaffoldKey,
                children: [
                  widget.child,
                  Positioned(
                    right: 16,
                    child: SafeArea(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: DrawerGestureDetector(
                          callback: _showDebugPanel,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  void _showLogsDialog() async {
    if (_navigatorKey.currentContext == null) return;
    final logs = LogRecordsContainer.instance.logs
        .map((LogMessage log) =>
            DebugLog(message: log.toString(), type: log.type.toLogType()))
        .toList();
    final incomingLogs = DebugMenuLogContainer.messages;
    logs.addAll(incomingLogs);
    showDialog(
        context: _navigatorKey.currentContext!,
        builder: (context) {
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
