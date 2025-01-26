import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/features/dock/widgets/dock.dart';
import 'package:untitled/features/dock/widgets/reorderable_item.dart';
import 'application/dock_controller.dart';

class DockPage extends StatelessWidget {
  DockPage({super.key});

  final DockController _dockController = Get.put(DockController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          final icons = _dockController.dockItems
              .map((index) => _dockController.getIcon(index))
              .toList();

          return Dock<IconData>(
            items: icons,
            builder: (e) => ReorderableItem(
              color: Colors.primaries[e.hashCode % Colors.primaries.length],
              icon: e,
              popoverText: 'Icon ${e.codePoint}',
            ),
            onReorder: (newIcons) {
              final newIndices = newIcons
                  .map((e) => _dockController.iconSet.indexOf(e))
                  .toList();
              _dockController.updateDockItems(newIndices);
            },
          );
        }),
      ),
    );
  }
}
