import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DrawerGestureDetector extends StatelessWidget {
  final void Function() callback;

  const DrawerGestureDetector({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        LongPressGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
                () => LongPressGestureRecognizer(),
                (LongPressGestureRecognizer instance) {
          instance.onLongPressMoveUpdate = (details) {
            if (details.offsetFromOrigin.dy > 70) {
              callback();
            }
          };
        }),
      },
    );
  }
}
