import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/dock/application/dock_controller.dart';
import 'features/dock/dock_page.dart';

void main() {
  Get.put(DockController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'Dock Demo',
      debugShowCheckedModeBanner: false,
      home: DockPage(),
    );
  }
}
