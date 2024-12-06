import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class DockController extends GetxController {
  /// Predefined set of icons.
  final List<IconData> iconSet = [
    Icons.person,
    Icons.message,
    Icons.call,
    Icons.camera,
    Icons.photo,
  ];

  /// Observable list of indices referencing `_iconSet`.
  var dockItems = <int>[].obs;

  /// Default indices corresponding to `_iconSet`.
  final List<int> _defaultIndices = [0, 1, 2, 3, 4];

  @override
  void onInit() {
    super.onInit();
    dockItems.addAll(_defaultIndices); // Initialize with default indices
    _loadDockState();
  }

  /// Load dock state from SharedPreferences.
  Future<void> _loadDockState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('dock_items');
    if (savedData != null) {
      final indices = (json.decode(savedData) as List).cast<int>();
      // Filter out invalid indices
      final validIndices = indices.where((index) => index >= 0 && index < iconSet.length).toList();
      dockItems.assignAll(validIndices.isEmpty ? _defaultIndices : validIndices);
    } else {
      dockItems.assignAll(_defaultIndices);
    }
  }

  /// Save dock state to SharedPreferences.
  Future<void> saveDockState() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = json.encode(dockItems);
    await prefs.setString('dock_items', encodedData);
  }

  /// Update dock items with new indices.
  void updateDockItems(List<int> newIndices) {
    dockItems.assignAll(newIndices);
    saveDockState();
  }

  /// Retrieve the icon corresponding to an index.
  IconData getIcon(int index) {
    if (index >= 0 && index < iconSet.length) {
      return iconSet[index];
    }
    // Fallback to a default icon in case of an invalid index
    return Icons.error;
  }
}
