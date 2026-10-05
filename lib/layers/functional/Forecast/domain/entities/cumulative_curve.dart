List<double> cumulativeCurve(List<double> daily, {int? length}) {
  final curve = <double>[];
  var total = 0.0;
  for (final value in daily.take(length ?? daily.length)) {
    total += value;
    curve.add(total);
  }
  return curve;
}
