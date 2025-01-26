import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

class ReorderableItem extends StatefulWidget {
  const ReorderableItem({
    super.key,
    required this.icon,
    required this.color,
    required this.popoverText,
    this.isHovering = false,
    this.hideWithAnimation = false,
  });

  final Color color;
  final IconData icon;
  final String popoverText;
  final bool hideWithAnimation;
  final bool isHovering;
  @override
  ReorderableItemState createState() => ReorderableItemState();
}

class ReorderableItemState extends State<ReorderableItem> with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    if (widget.hideWithAnimation) {
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      );
    }
  }

  @override
  void dispose() {
    if (widget.hideWithAnimation) {
      _animationController.dispose();
    }
    super.dispose();
  }

  void _showPopover(BuildContext context) {
    showPopover(
      context: context,
      bodyBuilder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.popoverText,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      onPop: () {
        if (widget.hideWithAnimation) {
          _animationController.reverse();
        }
      },
      direction: PopoverDirection.top,
      width: 200,
      height: 50,
      arrowHeight: 10,
    );

    if (widget.hideWithAnimation) {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovering = true);
        if (widget.hideWithAnimation) {
          _showPopover(context);
        }
      },
      onExit: (_) {
        setState(() => _isHovering = false);
      },
      child: GestureDetector(
        onTap: () {
          if (!widget.hideWithAnimation) {
            _showPopover(context);
          }
        },
        child: ScaleTransition(
          scale: widget.hideWithAnimation
              ? Tween<double>(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
          )
              : const AlwaysStoppedAnimation(1.0),
          child: Container(
            constraints: const BoxConstraints(minWidth: 48),
            height: 48,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: widget.color,
            ),
            child: Center(
              child: Icon(widget.icon, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
