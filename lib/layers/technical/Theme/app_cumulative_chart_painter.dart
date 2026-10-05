import 'dart:math';

import 'package:flutter/material.dart';

import 'app_chart_paths.dart';
import 'app_cumulative_chart_data.dart';
import 'app_tokens.dart';

class AppCumulativeChartPainter extends CustomPainter {
  final AppCumulativeChartData data;
  final AppTokens tokens;
  final String Function(double value) formatValue;
  final String? targetCaption;

  AppCumulativeChartPainter({required this.data, required this.tokens, required this.formatValue, this.targetCaption});

  bool get _graphite => tokens.isGraphite;

  late double _left, _right, _top, _bottom, _maxValue;

  double _x(num day, int length) => _left + (day - 1) / max(1, length - 1) * (_right - _left);

  double _y(double value) => _bottom - value / _maxValue * (_bottom - _top);

  TextPainter _text(String text, Color color, {bool bold = false}) => TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: _graphite ? 'GeistMono' : 'Manrope',
        fontSize: 10,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
        color: color,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();

  Paint get _gridPaint => Paint()
    ..color = tokens.grid
    ..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Size size) {
    _left = _graphite ? 2.0 : 34.0;
    _right = size.width - 2;
    _top = 10.0;
    _bottom = size.height - 26;
    final previousMax = data.previousValues.isEmpty ? 0.0 : data.previousValues.last;
    _maxValue = [data.target, data.projectedEnd, previousMax, data.currentValue, 10.0].reduce(max) * 1.08;
    _paintGrid(canvas);
    if (data.target > 0) _paintTarget(canvas);
    if (data.previousValues.isNotEmpty) _paintPrevious(canvas);
    final todayX = _x(data.currentDay, data.periodLength);
    canvas.drawLine(Offset(todayX, _top), Offset(todayX, _bottom), _gridPaint);
    if (data.projectedValues.length > 1) _paintProjection(canvas);
    _paintActual(canvas, Offset(todayX, _y(data.currentValue)));
    _paintDayAxis(canvas, size, todayX);
  }

  void _paintGrid(Canvas canvas) {
    final step = AppChartPaths.niceStep(_maxValue);
    for (double value = step; value < _maxValue; value += step) {
      if (data.target > 0 && (value - data.target).abs() < step * 0.35) continue;
      canvas.drawLine(Offset(_left, _y(value)), Offset(_right, _y(value)), _gridPaint);
      final label = _text(formatValue(value), _graphite ? tokens.faint : tokens.muted);
      label.paint(
        canvas,
        _graphite
            ? Offset(_right - label.width, _y(value) - label.height - 2)
            : Offset(0, _y(value) - label.height / 2),
      );
    }
    canvas.drawLine(
      Offset(_left, _bottom),
      Offset(_right, _bottom),
      Paint()
        ..color = _graphite ? tokens.lineStrong : tokens.grid
        ..strokeWidth = 1,
    );
  }

  void _paintTarget(Canvas canvas) {
    final targetY = _y(data.target);
    final paint = Paint()
      ..color = _graphite ? tokens.faint : tokens.warn
      ..strokeWidth = 1;
    AppChartPaths.drawDashed(
      canvas,
      Path()
        ..moveTo(_left, targetY)
        ..lineTo(_right, targetY),
      paint,
      2,
      4,
    );
    final formatted = formatValue(data.target);
    final caption = _graphite && targetCaption != null ? '$targetCaption $formatted' : formatted;
    final label = _text(caption, _graphite ? tokens.muted : tokens.warn, bold: true);
    label.paint(canvas, _graphite ? Offset(_right - label.width, targetY + 4) : Offset(0, targetY - label.height / 2));
  }

  void _paintPrevious(Canvas canvas) {
    final points = [
      for (var i = 0; i < data.previousValues.length; i++)
        Offset(_x(i + 1, data.previousPeriodLength), _y(data.previousValues[i])),
    ];
    canvas.drawPath(
      AppChartPaths.polyline(points),
      Paint()
        ..color = tokens.ghost
        ..style = PaintingStyle.stroke
        ..strokeWidth = _graphite ? 1.2 : 1.5
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  void _paintProjection(Canvas canvas) {
    final points = [
      for (var i = 0; i < data.projectedValues.length; i++)
        Offset(_x(data.currentDay + i, data.periodLength), _y(data.projectedValues[i])),
    ];
    final color = _graphite ? tokens.muted : tokens.mint;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _graphite ? 1.5 : 2
      ..strokeCap = StrokeCap.round;
    AppChartPaths.drawDashed(canvas, AppChartPaths.polyline(points), stroke, _graphite ? 2 : 4, _graphite ? 4 : 5);
    canvas.drawCircle(points.last, 3.5, Paint()..color = _graphite ? tokens.bg : tokens.card);
    canvas.drawCircle(
      points.last,
      3.5,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = _graphite ? 1.5 : 2,
    );
  }

  void _paintActual(Canvas canvas, Offset today) {
    final points = [
      for (var i = 0; i < data.actualValues.length; i++) Offset(_x(i + 1, data.periodLength), _y(data.actualValues[i])),
    ];
    if (points.length > 1) {
      canvas.drawPath(
        AppChartPaths.polyline(points),
        Paint()
          ..color = _graphite ? tokens.ink : tokens.mint
          ..style = PaintingStyle.stroke
          ..strokeWidth = _graphite ? 1.5 : 2.5
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round,
      );
    }
    if (!_graphite) canvas.drawCircle(today, 6.5, Paint()..color = tokens.card);
    canvas.drawCircle(today, _graphite ? 4 : 4.5, Paint()..color = _graphite ? tokens.accent : tokens.mint);
  }

  void _paintDayAxis(Canvas canvas, Size size, double todayX) {
    final day = data.currentDay;
    for (final tick in {1, 8, 15, 22, data.periodLength}) {
      if ((tick - day).abs() <= 2 && tick != day) continue;
      final label = _text('$tick', _graphite ? tokens.faint : tokens.muted);
      final dx = (_x(tick, data.periodLength) - label.width / 2).clamp(0.0, size.width - label.width);
      label.paint(canvas, Offset(dx, _bottom + 10));
    }
    final todayLabel = _text('$day', _graphite ? tokens.accent : tokens.mint, bold: true);
    todayLabel.paint(
      canvas,
      Offset((todayX - todayLabel.width / 2).clamp(0.0, size.width - todayLabel.width), _bottom + 10),
    );
  }

  @override
  bool shouldRepaint(AppCumulativeChartPainter oldDelegate) =>
      oldDelegate.data != data || oldDelegate.tokens != tokens || oldDelegate.targetCaption != targetCaption;
}
