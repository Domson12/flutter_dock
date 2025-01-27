import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:untitled/features/dock/application/models/dock_item.dart';

class DockController extends GetxController {
  /// List of all available Dock items
  final RxList<DockItem> dockItemModels = <DockItem>[
    DockItem(iconData: Icons.person, label: 'Person', indexInController: 0),
    DockItem(iconData: Icons.message, label: 'Message', indexInController: 1),
    DockItem(iconData: Icons.call, label: 'Call', indexInController: 2),
    DockItem(iconData: Icons.camera, label: 'Camera', indexInController: 3),
    DockItem(iconData: Icons.photo, label: 'Photo', indexInController: 4),
  ].obs;

  /// Tracks the current order of items
  final RxList<int> dockItems = <int>[0, 1, 2, 3, 4].obs;

  /// Returns the icon for a Dock item at a given index
  IconData getIcon(int index) {
    if (index < 0 || index >= dockItemModels.length) return Icons.error;
    return dockItemModels[index].iconData;
  }

  /// Updates the order of items
  void updateDockItems(List<int> newIndices) {
    dockItems.assignAll(newIndices);
  }
}
