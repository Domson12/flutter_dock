import 'package:flutter/material.dart';
import 'package:untitled/features/dock/widgets/tear_popover.dart';

/// Creates a [ReorderableItem] widget
///
/// - [icon] is the icon displayed in the Dock
/// - [color] is the background color of the item
/// - [label] is the text shown in the popover when the item is hovered
/// - [isHovering] determines whether the item is currently hovered
/// - [isDragging] determines whether the item is currently being dragged
class ReorderableItem extends StatelessWidget {
  const ReorderableItem({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.isHovering,
    required this.isDragging,
  });

  ///icon displayed in the Dock
  final IconData icon;

  /// background color of the item
  final Color color;

  /// text shown in the popover when the item is hovered
  final String label;

  /// Whether this item is currently hovered
  final bool isHovering;

  /// Whether this item is currently being dragged
  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          constraints: const BoxConstraints(minWidth: 48),
          height: 48,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color,
          ),
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),

        /// Displays a popover above the itemm
        if (isHovering && !isDragging)
          Positioned(
            top: -60,
            child: TeardropPopover(
              color: Colors.white,
              borderColor: Colors.grey,
              borderWidth: 1.0,
              cornerRadius: 8.0,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
