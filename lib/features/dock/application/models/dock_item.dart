import 'package:flutter/material.dart';

class DockItem {
  DockItem({
    required this.iconData,
    required this.label,
    required this.indexInController,
  }) : key = ValueKey(label);

  final IconData iconData;
  final String label;

  /// Maps to DockController’s dockItemModels list index.
  final int indexInController;

  final Key key;

  Offset position = Offset.zero;
  Offset originalPosition = Offset.zero;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DockItem && other.key == key;
  }

  @override
  int get hashCode => key.hashCode;
}
