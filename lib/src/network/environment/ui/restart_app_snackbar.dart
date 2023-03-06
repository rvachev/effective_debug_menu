import 'package:flutter/material.dart';

class RestartAppSnackBar extends SnackBar {
  const RestartAppSnackBar({super.key})
      : super(
          content: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Restart app to apply changes'),
          ),
        );
}
