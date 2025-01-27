import 'package:flutter/material.dart';
import 'package:untitled/features/dock/widgets/dock.dart';

class DockPage extends StatelessWidget {
  const DockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Dock(),
            ),
          ),
        ],
      ),
    );
  }
}
