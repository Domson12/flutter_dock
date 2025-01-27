import 'package:flutter/material.dart';
import 'package:untitled/features/dock/widgets/tear_popover.dart';

class ReorderableItem extends StatelessWidget {
  const ReorderableItem({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.isHovering,
    required this.isDragging,
  });

  final IconData icon;
  final Color color;
  final String label;

  /// Tells us if this item is hovered in the Dock (used for showing popover).
  final bool isHovering;

  /// Tells us if this item is currently being dragged.
  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // so the popover can extend outside
      alignment: Alignment.center,
      children: [
        // The main item (48px box with margin, color, icon, etc.)
        Container(
          constraints: const BoxConstraints(minWidth: 48),
          height: 48,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color,
          ),
          child: Center(
            child: Icon(icon, color: Colors.white),
          ),
        ),

        // The teardrop popover, only show if hovered & not dragging
        if (isHovering && !isDragging)
          Positioned(
            top: -60, // place it above the item
            child: TeardropPopover(
              color: Colors.white,
              borderColor: Colors.grey,
              borderWidth: 1.0,
              cornerRadius: 8.0,
              child: Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ),
      ],
    );
  }
}
