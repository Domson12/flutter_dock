import 'package:flutter/material.dart';

class DockItem {
  /// Creates a [DockItem]
  DockItem({
    required this.iconData,
    required this.label,
    required this.indexInController,
  }) : key = ValueKey(label);

  /// icon displayed in the Dock
  final IconData iconData;

  /// label associated with this item
  final String label;

  /// index of this item
  final int indexInController;

  /// A unique key to identify this [DockItem]
  final Key key;

  /// The current position
  Offset position = Offset.zero;

  /// The item original positiong
  Offset originalPosition = Offset.zero;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DockItem && other.key == key;
  }

  @override
  int get hashCode => key.hashCode;
}
