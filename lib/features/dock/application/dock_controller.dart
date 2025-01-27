import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:untitled/features/dock/application/models/dock_item.dart';

/// Simple DockController that holds a list of DockItem objects in memory.
class DockController extends GetxController {
  // List of DockItems available for the dock.
  final RxList<DockItem> dockItemModels = <DockItem>[
    DockItem(iconData: Icons.person, label: 'Person', indexInController: 0),
    DockItem(iconData: Icons.message, label: 'Message', indexInController: 1),
    DockItem(iconData: Icons.call, label: 'Call', indexInController: 2),
    DockItem(iconData: Icons.camera, label: 'Camera', indexInController: 3),
    DockItem(iconData: Icons.photo, label: 'Photo', indexInController: 4),
  ].obs;

  // The list of indices (from dockItemModels) that are in the dock, in order.
  // Default: [0, 1, 2, 3, 4].
  final RxList<int> dockItems = <int>[0, 1, 2, 3, 4].obs;

  /// Retrieve IconData based on the index in dockItemModels.
  IconData getIcon(int index) {
    if (index < 0 || index >= dockItemModels.length) return Icons.error;
    return dockItemModels[index].iconData;
  }

  /// Update the order of icons:
  void updateDockItems(List<int> newIndices) {
    dockItems.assignAll(newIndices);
  }
}
