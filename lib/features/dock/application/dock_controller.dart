import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class DockController extends GetxController {
  /// Observable list of items for the dock.
  var dockItems = <IconData>[].obs;

  /// Default items.
  final List<IconData> _defaultItems = [
    Icons.person,
    Icons.message,
    Icons.call,
    Icons.camera,
    Icons.photo,
  ];

  @override
  void onInit() {
    super.onInit();
    dockItems.addAll(_defaultItems); // Initialize with defaults
    _loadDockState();
  }

  /// Load dock state from SharedPreferences.
  Future<void> _loadDockState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('dock_items');
    if (savedData != null) {
      final decodedData = (json.decode(savedData) as List)
          .map((item) => IconData(item, fontFamily: 'MaterialIcons'))
          .toList();
      dockItems.assignAll(decodedData);
    }
  }

  /// Save dock state to SharedPreferences.
  Future<void> saveDockState() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData =
    json.encode(dockItems.map((e) => e.codePoint).toList());
    await prefs.setString('dock_items', encodedData);
  }

  /// Update dock items after reordering.
  void updateDockItems(List<IconData> newItems) {
    dockItems.assignAll(newItems);
    saveDockState();
  }
}
