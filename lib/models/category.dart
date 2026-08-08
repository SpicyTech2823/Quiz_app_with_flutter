import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData? icon;
  final Color? color;

  Category({
    required this.id,
    required this.name,
    this.icon,
    this.color,
  });
}
