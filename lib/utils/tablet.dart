import 'package:flutter/material.dart';

String getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  return data.size.shortestSide < 550 ? 'phone' : 'tablet';
}
