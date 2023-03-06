import 'package:flutter/material.dart';

class DrawerGestureDetector extends StatelessWidget {
  final void Function() callback;

  const DrawerGestureDetector({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressMoveUpdate: (details) {
        if (details.offsetFromOrigin.dy > 70) {
          callback();
        }
      },
    );
  }
}
