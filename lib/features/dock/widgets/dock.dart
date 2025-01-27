import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/features/dock/widgets/reorderable_item.dart';
import '../application/dock_controller.dart';
import '../application/models/dock_item.dart';

class Dock extends StatefulWidget {
  const Dock({super.key});

  @override
  State<Dock> createState() => _DockState();
}

class _DockState extends State<Dock> {
  /// The Dock controller instance
  final DockController controller = Get.find<DockController>();

  /// List of Dock items
  List<DockItem> items = [];

  /// The index of the currently hovered item
  int? hoveredIndex;

  /// Dock item size
  double baseItemHeight = 50;
  double baseTranslationYaxis = 0;
  double verticalPadding = 10;

  /// Key for the Dock container
  final GlobalKey _dockKey = GlobalKey();

  /// Tracks the drag state
  bool isDragging = false;
  Offset dragOffset = Offset.zero;
  bool goBackToOriginalPosition = true;
  int? draggingIndex;
  double dockWidth = 0.0;

  @override
  void initState() {
    super.initState();
    ever<List<int>>(controller.dockItems, (_) => _rebuildItems());
    _rebuildItems();
  }

  /// Builds the list of Dock items
  void _rebuildItems() {
    final iconIndices = controller.dockItems;
    final newItems = <DockItem>[];

    for (int i = 0; i < iconIndices.length; i++) {
      final model = controller.dockItemModels[iconIndices[i]];
      newItems.add(
        DockItem(
          iconData: model.iconData,
          label: model.label,
          indexInController: model.indexInController,
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      /// Calculate positions for each item
      final screenWidth = MediaQuery.of(context).size.width;
      const itemSpacing = 10;

      final totalWidth = newItems.length * (baseItemHeight + itemSpacing);
      final startX = ((screenWidth - totalWidth) / 2) + 4;
      final centerY = MediaQuery.of(context).size.height / 2 - 42;

      for (int i = 0; i < newItems.length; i++) {
        newItems[i].position =
            Offset(startX + (i * (baseItemHeight + itemSpacing)), centerY);
        newItems[i].originalPosition = newItems[i].position;
      }

      setState(() {
        items = newItems;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    dockWidth = _calculateDockWidth();

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedContainer(
          key: _dockKey,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          height: baseItemHeight + 16,
          width: dockWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black12,
          ),
          padding: const EdgeInsets.all(4),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: Stack(
            clipBehavior: Clip.none,
            children: List.generate(items.length, (index) {
              final scaledSize = _getScaledSize(index);
              final scale = scaledSize / baseItemHeight;
              final itemPosition = items[index].position;

              return AnimatedPositioned(
                key: items[index].key,
                duration: Duration(
                  milliseconds:
                      goBackToOriginalPosition && draggingIndex != index
                          ? 400
                          : 0,
                ),
                curve: Curves.easeInOut,
                left: itemPosition.dx,
                top: itemPosition.dy,
                child: MouseRegion(
                  onEnter: (_) => setState(() => hoveredIndex = index),
                  onExit: (_) => setState(() => hoveredIndex = null),
                  child: GestureDetector(
                    onPanStart: (details) => _handlePanStart(index, details),
                    onPanUpdate: (details) => _handlePanUpdate(index, details),
                    onPanEnd: (details) => _handlePanEnd(index, details),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      transform: Matrix4.identity()
                        ..translate(
                          (baseItemHeight - scaledSize) / 2,
                          _getTranslationY(index),
                        ),
                      height: baseItemHeight,
                      width: scaledSize,
                      alignment: Alignment.bottomCenter,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        scale: scale,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ReorderableItem(
                            icon: items[index].iconData,
                            color: Colors.primaries[
                                items[index].iconData.hashCode %
                                    Colors.primaries.length],
                            label: items[index].label,
                            isHovering: (hoveredIndex == index),
                            isDragging: (draggingIndex == index),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            })
              ..sort((a, b) {
                final aIndex = items.indexWhere((item) => item.key == a.key);
                final bIndex = items.indexWhere((item) => item.key == b.key);
                if (draggingIndex == aIndex) return 1;
                if (draggingIndex == bIndex) return -1;
                return 0;
              }),
          ),
        ),
      ],
    );
  }

  /// Determines the scaled size for an item
  double _getScaledSize(int index) {
    return _getPropertyValue(
      index: index,
      baseValue: baseItemHeight,
      maxValue: 70,
      nonHoveredMaximumValue: 60,
    );
  }

  /// Calculates the vertical translation
  double _getTranslationY(int index) {
    return _getPropertyValue(
      index: index,
      baseValue: baseTranslationYaxis,
      maxValue: -10,
      nonHoveredMaximumValue: -5,
    );
  }

  /// Calculates the property value based on the hovered index
  double _getPropertyValue({
    required int index,
    required double baseValue,
    required double maxValue,
    required double nonHoveredMaximumValue,
  }) {
    if (hoveredIndex == null) return baseValue;

    final diff = (hoveredIndex! - index).abs();
    final itemsAffected = items.length;

    if (diff == 0) {
      return maxValue;
    } else if (diff <= itemsAffected) {
      final ratio = (itemsAffected - diff) / itemsAffected;
      return lerpDouble(baseValue, nonHoveredMaximumValue, ratio)!;
    } else {
      return baseValue;
    }
  }

  /// Calculates the total width of the Dock
  double _calculateDockWidth() {
    return items.fold(0.0, (total, item) {
      final i = items.indexOf(item);
      final scaled = _getScaledSize(i);
      return total + scaled + 10;
    });
  }

  /// Handles the start of a drag
  void _handlePanStart(int index, DragStartDetails details) {
    setState(() {
      draggingIndex = index;

      final dockBox = _dockKey.currentContext?.findRenderObject() as RenderBox?;
      if (dockBox != null) {
        dragOffset = items[index].position -
            dockBox.globalToLocal(details.globalPosition);
      }

      isDragging = true;
    });
  }

  /// Handles updates during a drag gesture
  void _handlePanUpdate(int index, DragUpdateDetails details) {
    final dockBox = _dockKey.currentContext?.findRenderObject() as RenderBox?;
    if (dockBox == null) return;

    setState(() {
      final dockPosition = dockBox.localToGlobal(Offset.zero);
      final itemWidth = baseItemHeight + 10;
      final newPosition =
          dockBox.globalToLocal(details.globalPosition) + dragOffset;

      items[index].position = newPosition;

      if (_isInsideDock(details.globalPosition)) {
        final relativeX = newPosition.dx - dockPosition.dx;
        int targetIndex = (relativeX / itemWidth).round();
        targetIndex = targetIndex.clamp(0, items.length - 1);

        final baseX = items[0].originalPosition.dx;
        final baseY = items[0].originalPosition.dy;

        if (targetIndex > index) {
          for (int i = 0; i < items.length; i++) {
            if (i == index) continue;
            if (i < index) {
              items[i].position = Offset(baseX + (i * itemWidth), baseY);
            } else if (i <= targetIndex) {
              items[i].position = Offset(baseX + ((i - 1) * itemWidth), baseY);
            } else {
              items[i].position = Offset(baseX + (i * itemWidth), baseY);
            }
          }
        } else {
          for (int i = 0; i < items.length; i++) {
            if (i == index) continue;
            if (i < targetIndex) {
              items[i].position = Offset(baseX + (i * itemWidth), baseY);
            } else if (i < index) {
              items[i].position = Offset(baseX + ((i + 1) * itemWidth), baseY);
            } else {
              items[i].position = Offset(baseX + (i * itemWidth), baseY);
            }
          }
        }
      } else {
        for (int i = 0; i < items.length; i++) {
          if (i != index) {
            items[i].position = items[i].originalPosition;
          }
        }
      }
    });
  }

  /// Handles the end of a drag gesture
  void _handlePanEnd(int index, DragEndDetails details) {
    setState(() {
      if (!_isInsideDock(details.globalPosition)) {
        items[index].position = items[index].originalPosition;
      } else {
        final dockBox =
            _dockKey.currentContext?.findRenderObject() as RenderBox?;
        if (dockBox != null) {
          final dockStartX = dockBox.localToGlobal(Offset.zero).dx + 26;

          final draggedItem = items.removeAt(index);

          int newIndex = items.length;
          for (int i = 0; i < items.length; i++) {
            if (items[i].position.dx > draggedItem.position.dx) {
              newIndex = i;
              break;
            }
          }
          items.insert(newIndex, draggedItem);

          const itemSpacing = 60;
          for (int i = 0; i < items.length; i++) {
            final newPos = Offset(
              dockStartX + i * itemSpacing,
              items[0].originalPosition.dy,
            );
            items[i].position = newPos;
            items[i].originalPosition = newPos;
          }

          final newOrder = items.map((e) => e.indexInController).toList();
          controller.updateDockItems(newOrder);
        }
      }

      draggingIndex = null;
      isDragging = false;
      goBackToOriginalPosition = true;
    });
  }

  /// Determines if a point is inside the Dock container
  bool _isInsideDock(Offset globalPos) {
    final dockBox = _dockKey.currentContext?.findRenderObject() as RenderBox?;
    if (dockBox == null) return false;
    final dockBounds = dockBox.localToGlobal(Offset.zero) & dockBox.size;
    return dockBounds.contains(globalPos);
  }
}
