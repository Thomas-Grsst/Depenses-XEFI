import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entities/hypothesis.dart';
import 'simulations_locale.dart';

const _alphabetLength = 26;
const _firstLetterCode = 65;
const _monthsShownWithoutYear = 6;

extension SimulationsLabels on BuildContext {
  String scenarioLetter(int position) =>
      position < _alphabetLength ? String.fromCharCode(_firstLetterCode + position) : '${position + 1}';

  String hypothesisSummary(Hypothesis hypothesis) {
    final amount = money.autoEuros(hypothesis.newAmount);
    if (hypothesis.isNew) return trWith(SimulationsLocale.hypothesisNew, [hypothesis.name, amount]);
    if (!hypothesis.isKept) return trWith(SimulationsLocale.hypothesisWithout, [hypothesis.name]);
    return trWith(SimulationsLocale.hypothesisChanged, [hypothesis.name, amount]);
  }

  String amountWithFrequency(double amount, Frequency frequency) {
    final formatted = money.autoEuros(amount);
    return switch (frequency) {
      Frequency.week => trWith(SimulationsLocale.amountPerWeek, [formatted]),
      Frequency.year => trWith(SimulationsLocale.amountPerYear, [formatted]),
      Frequency.month => formatted,
    };
  }

  String monthAfter(DateTime today, int months) {
    final month = DateTime(today.year, today.month + months);
    final name = dates.monthName(month);
    if (month.year == today.year || months <= _monthsShownWithoutYear) return name;
    return trWith(SimulationsLocale.monthWithYear, [name, '${month.year}']);
  }

  String goalWhen(DateTime today, int? months) {
    if (months == null) return tr(SimulationsLocale.goalNever);
    if (months == 0) return tr(SimulationsLocale.reached);
    return trWith(SimulationsLocale.goalReachedIn, [monthAfter(today, months)]);
  }
}
