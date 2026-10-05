import 'dart:math';

import 'package:flutter/material.dart';

abstract final class AppChartPaths {
  static void drawDashed(Canvas canvas, Path path, Paint paint, double dash, double gap) {
    for (final metric in path.computeMetrics()) {
      for (double distance = 0; distance < metric.length; distance += dash + gap) {
        canvas.drawPath(metric.extractPath(distance, min(distance + dash, metric.length)), paint);
      }
    }
  }

  static Path polyline(List<Offset> points) {
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      i == 0 ? path.moveTo(points[i].dx, points[i].dy) : path.lineTo(points[i].dx, points[i].dy);
    }
    return path;
  }

  static double niceStep(double maxValue) {
    if (maxValue <= 0) return 100;
    final raw = maxValue / 3;
    final magnitude = pow(10, (log(raw) / ln10).floor()).toDouble();
    for (final multiplier in [1, 2, 2.5, 5, 10]) {
      if (multiplier * magnitude >= raw) return multiplier * magnitude;
    }
    return 10 * magnitude;
  }
}
