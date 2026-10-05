import 'dart:math';

import 'package:flutter/material.dart';

import 'app_chart_paths.dart';
import 'app_cumulative_chart_data.dart';
import 'app_tokens.dart';
import 'app_tokens_context.dart';

class AppSparkline extends StatelessWidget {
  final AppCumulativeChartData data;
  final double height;
  final Color? color;

  const AppSparkline({super.key, required this.data, this.height = 36, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _AppSparklinePainter(data: data, tokens: context.tokens, color: color),
      ),
    );
  }
}

class _AppSparklinePainter extends CustomPainter {
  final AppCumulativeChartData data;
  final AppTokens tokens;
  final Color? color;

  const _AppSparklinePainter({required this.data, required this.tokens, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final graphite = tokens.isGraphite;
    final maxValue = max(max(data.projectedEnd, data.currentValue), 1.0);
    const inset = 4.0;
    double x(num day) => inset + (day - 1) / max(1, data.periodLength - 1) * (size.width - 2 * inset);
    double y(double value) => size.height - inset - value / maxValue * (size.height - 2 * inset);
    final lineColor = color ?? (graphite ? tokens.ink : tokens.mint);
    final actual = [for (var i = 0; i < data.actualValues.length; i++) Offset(x(i + 1), y(data.actualValues[i]))];
    final projected = [
      for (var i = 0; i < data.projectedValues.length; i++) Offset(x(data.currentDay + i), y(data.projectedValues[i])),
    ];
    if (projected.length > 1) {
      final dashedPaint = Paint()
        ..color = graphite ? tokens.muted : lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = graphite ? 1.5 : 2
        ..strokeCap = StrokeCap.round;
      AppChartPaths.drawDashed(canvas, AppChartPaths.polyline(projected), dashedPaint, graphite ? 2 : 3, 4);
    }
    if (actual.length > 1) {
      final linePaint = Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = graphite ? 1.5 : 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(AppChartPaths.polyline(actual), linePaint);
    }
    if (actual.isNotEmpty) {
      canvas.drawCircle(actual.last, graphite ? 4 : 3, Paint()..color = graphite ? tokens.accent : lineColor);
    }
  }

  @override
  bool shouldRepaint(_AppSparklinePainter oldDelegate) =>
      oldDelegate.data != data || oldDelegate.tokens != tokens || oldDelegate.color != color;
}
