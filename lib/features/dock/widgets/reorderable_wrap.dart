import 'package:flutter/material.dart';
import 'package:springster/springster.dart';

class ReorderableWrap<T extends Object> extends StatefulWidget {
  const ReorderableWrap({
    super.key,
    required this.items,
    required this.builder,
    this.onReorder,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
  });

  /// List of items to display and reorder.
  final List<T> items;

  /// Builder function for rendering each item.
  final Widget Function(T) builder;

  /// Callback triggered after items are reordered.
  final void Function(List<T>)? onReorder;

  /// Horizontal spacing between items.
  final double spacing;

  /// Vertical spacing between rows of items.
  final double runSpacing;

  @override
  State<ReorderableWrap<T>> createState() => _ReorderableWrapState<T>();
}

class _ReorderableWrapState<T extends Object> extends State<ReorderableWrap<T>> {
  late List<T> _items;
  T? _draggingItem;
  int? _targetIndex;

  @override
  void initState() {
    super.initState();
    _items = widget.items.toList();
  }

  void _reorderItems(T draggedItem, int targetIndex) {
    setState(() {
      final oldIndex = _items.indexOf(draggedItem);
      if (oldIndex != -1) {
        _items.removeAt(oldIndex);
        if (oldIndex < targetIndex) targetIndex -= 1;
        _items.insert(targetIndex, draggedItem);

        widget.onReorder?.call(_items);
      }
      _draggingItem = null;
      _targetIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
      children: [
        for (int index = 0; index < _items.length; index++) ...[
          // Insert placeholder gap when dragging
          if (_draggingItem != null &&
              _targetIndex == index &&
              !_items.contains(_draggingItem))
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: SizedBox(
                key: ValueKey('placeholder-$index'),
                width: 80.0, // Adjust based on your item size
                height: 80.0, // Adjust based on your item size
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

          // Draggable item
          SpringDraggable<T>(
            data: _items[index],
            onDragStarted: () {
              setState(() {
                _draggingItem = _items[index];
              });
            },
            onDragEnd: (_) {
              setState(() {
                _draggingItem = null;
                _targetIndex = null;
              });
            },
            feedback: Material(
              color: Colors.transparent,
              child: Opacity(
                opacity: 0.75,
                child: widget.builder(_items[index]),
              ),
            ),
            childWhenDragging: const SizedBox.shrink(),
            child: DragTarget<T>(
              onWillAcceptWithDetails: (details) {
                if (details.data != _draggingItem) {
                  setState(() {
                    _targetIndex = index;
                  });
                }
                return details.data != _draggingItem;
              },
              onAcceptWithDetails: (details) =>
                  _reorderItems(details.data, index),
              builder: (context, candidateData, rejectedData) {
                final isActive = candidateData.isNotEmpty;
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: Stack(
                    key: ValueKey('item-$index'),
                    clipBehavior: Clip.none,
                    children: [
                      widget.builder(_items[index]),
                      if (isActive)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],

        if (_draggingItem != null &&
            _targetIndex == _items.length &&
            !_items.contains(_draggingItem))
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: SizedBox(
              key: const ValueKey('placeholder-end'),
              width: 80.0,
              height: 80.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
