import 'dart:math';

import 'hypothesis.dart';

const _largeAmount = 200.0;
const _mediumAmount = 20.0;
const _largeStep = 10.0;
const _mediumStep = 1.0;
const _smallStep = 0.5;
const _minimumHeadroom = 100.0;

class HypothesisScale {
  HypothesisScale.of(Hypothesis hypothesis)
    : step = hypothesis.oldAmount >= _largeAmount || hypothesis.newAmount >= _largeAmount
          ? _largeStep
          : (hypothesis.oldAmount >= _mediumAmount ? _mediumStep : _smallStep),
      maximum = max(max(hypothesis.oldAmount * 2, hypothesis.oldAmount + _minimumHeadroom), hypothesis.newAmount);

  final double step;
  final double maximum;

  double stepped(double amount, int direction) => max(0, ((amount + direction * step) / step).round() * step);

  double snapped(double amount) => (amount / step).round() * step;
}
