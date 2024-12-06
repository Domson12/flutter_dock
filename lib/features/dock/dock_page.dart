import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/features/dock/widgets/dock.dart';
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
            builder: (e) => Container(
              constraints: const BoxConstraints(minWidth: 48),
              height: 48,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.primaries[e.hashCode % Colors.primaries.length],
              ),
              child: Center(child: Icon(e, color: Colors.white)),
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
