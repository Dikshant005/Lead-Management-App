import 'package:flutter/material.dart';

class AppConstants {
  // Lead Status
  static const String statusNew = 'New';
  static const String statusContacted = 'Contacted';
  static const String statusConverted = 'Converted';
  static const String statusLost = 'Lost';

  static const List<String> statusList = [
    statusNew,
    statusContacted,
    statusConverted,
    statusLost,
  ];

  static const List<String> filterList = [
    'All',
    statusNew,
    statusContacted,
    statusConverted,
    statusLost,
  ];

  // Status Colors
  static Color getStatusColor(String status) {
    switch (status) {
      case statusNew:
        return Colors.blue;
      case statusContacted:
        return Colors.orange;
      case statusConverted:
        return Colors.green;
      case statusLost:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Status Icons
  static IconData getStatusIcon(String status) {
    switch (status) {
      case statusNew:
        return Icons.fiber_new;
      case statusContacted:
        return Icons.phone_in_talk;
      case statusConverted:
        return Icons.check_circle;
      case statusLost:
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}
