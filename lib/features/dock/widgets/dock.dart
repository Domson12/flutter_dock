import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
    this.onReorder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T) builder;

  /// Callback to notify when items are reordered.
  final void Function(List<T>)? onReorder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

class _DockState<T> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ReorderableWrap(
          spacing: 8.0,
          runSpacing: 0.0,
          direction: Axis.horizontal,
          scrollDirection: Axis.horizontal,
          alignment: WrapAlignment.start,
          buildDraggableFeedback: (context, constraints, child) {
            return Material(
              color: Colors.transparent,
              child: Container(
                constraints: constraints,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurStyle: BlurStyle.inner,
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: const Offset(0.5, 0.5),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: child,
              ),
            );
          },
          padding: const EdgeInsets.all(8),
          onReorder: (oldIndex, newIndex) {
            final item = _items.removeAt(oldIndex);
            _items.insert(newIndex, item);
            setState(() {});
            if (widget.onReorder != null) {
              widget.onReorder!(_items);
            }
          },
          children: _items.map((e) {
            return Container(
              color: Colors.transparent,
              key: ValueKey(e),
              child: widget.builder(e),
            );
          }).toList(),
        ),
      ),
    );
  }
}
