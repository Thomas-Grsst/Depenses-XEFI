import 'package:flutter/material.dart';

import 'app_cumulative_chart_data.dart';
import 'app_cumulative_chart_painter.dart';
import 'app_tokens_context.dart';

class AppCumulativeChart extends StatelessWidget {
  final AppCumulativeChartData data;
  final String Function(double value) formatValue;
  final String? targetCaption;
  final double height;

  const AppCumulativeChart({
    super.key,
    required this.data,
    required this.formatValue,
    this.targetCaption,
    this.height = 210,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: AppCumulativeChartPainter(
          data: data,
          tokens: context.tokens,
          formatValue: formatValue,
          targetCaption: targetCaption,
        ),
      ),
    );
  }
}
