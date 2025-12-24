import 'package:flutter/material.dart';

class DashboardItem {
  final IconData icon;
  final String title;
  final String value;
  final String update;
  final String percent;
  final VoidCallback onTap;

  DashboardItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.update,
    required this.percent,
    required this.onTap,
  });
}
