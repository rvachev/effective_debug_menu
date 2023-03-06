import 'package:flutter/material.dart';

import '../models/environment_item.dart';

class EnvironmentDropdown extends StatelessWidget {
  final EnvironmentItem selectedEnvironment;
  final List<EnvironmentItem> items;
  final void Function(EnvironmentItem item)? onEnvironmentChanged;

  const EnvironmentDropdown(
      {super.key,
      required this.selectedEnvironment,
      required this.items,
      this.onEnvironmentChanged});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButton<EnvironmentItem>(
          alignment: Alignment.center,
          isExpanded: true,
          value: selectedEnvironment,
          items: items
              .map(
                (item) => DropdownMenuItem<EnvironmentItem>(
                  value: item,
                  child: Text(item.name),
                ),
              )
              .toList(),
          selectedItemBuilder: (context) {
            return items
                .map((item) =>
                    Align(alignment: Alignment.center, child: Text(item.name)))
                .toList();
          },
          onChanged: (value) {
            if (value != null && onEnvironmentChanged != null) {
              onEnvironmentChanged!(value);
            }
          }),
    );
  }
}
