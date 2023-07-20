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

enum OpenGestureAlignment {
  topLeft(alignment: Alignment.topLeft),
  topCenter(alignment: Alignment.topCenter),
  topRight(alignment: Alignment.topRight);

  const OpenGestureAlignment({required this.alignment});

  final Alignment alignment;
}

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

  /// An aligment for start gesture position
  /// May be only on the top of the screen
  final OpenGestureAlignment openGestureAlignment;

  /// child (usually whole app) to place debug panel on the screen
  final Widget child;

  const DebugPanel({
    super.key,
    this.selectedEnvironment,
    this.environments = const [],
    this.onEnvironmentChanged,
    this.additionalItem,
    this.openGestureAlignment = OpenGestureAlignment.topLeft,
    required this.child,
  });

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
                  Align(
                    alignment: widget.openGestureAlignment.alignment,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: DrawerGestureDetector(
                            callback: _showDebugPanel,
                          ),
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
    if (_scaffoldKey.currentContext == null) return;
    final logs = LogRecordsContainer.instance.logs
        .map((LogMessage log) =>
            DebugLog(message: log.toString(), type: log.type.toLogType()))
        .toList();
    final incomingLogs = DebugMenuLogContainer.messages;
    logs.addAll(incomingLogs);
    showDialog(
        context: _scaffoldKey.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pop();
              return false;
            },
            child: Dialog(
              insetPadding: const EdgeInsets.all(20.0),
              child: Container(
                  color: Colors.white,
                  child: Stack(
                    children: [
                      LogsListView(
                        logs: logs,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Закрыть'),
                        ),
                      )
                    ],
                  )),
            ),
          );
        });
  }

  void _showDebugPanel() {
    Scaffold.of(_scaffoldKey.currentContext!).openEndDrawer();
  }
}
