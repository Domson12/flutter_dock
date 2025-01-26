import 'dart:math';
import 'package:flutter/material.dart';
import 'package:untitled/features/dock/widgets/reorderable_wrap.dart';

class Dock<T extends Object> extends StatefulWidget {
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

class _DockState<T extends Object> extends State<Dock<T>> with SingleTickerProviderStateMixin {
  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();


  double? _mouseXPosition;

  @override
  void initState() {
    super.initState();
  }

  double _calculateTargetScale(int index, BuildContext context) {
    if (_mouseXPosition == null) {
      return 1.0;
    }

    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return 1.0;

    final itemWidth = box.size.width / _items.length;
    final iconCenter = (index + 0.5) * itemWidth;
    final distance = (_mouseXPosition! - iconCenter).abs();

    const double maxDistance = 80.0;
    const double maxScale = 1.5;

    if (distance > maxDistance) return 1.0;

    final scale = maxScale - (distance / maxDistance) * (maxScale - 1.0);
    return max(1.0, scale);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _mouseXPosition = event.localPosition.dx;
        });
      },
      onExit: (_) {
        setState(() {
          _mouseXPosition = null;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black12,
        ),
        padding: const EdgeInsets.all(4),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ReorderableWrap<T>(
            items: _items,
            builder: (item) {
              final index = _items.indexOf(item);
              return TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                tween: Tween<double>(
                  begin: 1.0,
                  end: _calculateTargetScale(index, context),
                ),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: widget.builder(item),
              );
            },
            onReorder: (updatedItems) {
              setState(() {
                _items
                  ..clear()
                  ..addAll(updatedItems);
              });
              widget.onReorder?.call(updatedItems);
            },
            spacing: 8.0,
            runSpacing: 8.0,
          ),
        ),
      ),
    );
  }
}
