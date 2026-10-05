import 'package:flutter/widgets.dart';

List<Widget> spaced(Iterable<Widget> widgets, double gap) {
  final result = <Widget>[];
  for (final widget in widgets) {
    if (result.isNotEmpty) result.add(SizedBox(height: gap, width: gap));
    result.add(widget);
  }
  return result;
}
