import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:depenses/layers/technical/Storage/json_reading.dart';

import '../../domain/entities/hypothesis.dart';
import '../../domain/entities/scenario.dart';

abstract final class ScenarioModel {
  static Scenario fromJson(Map<String, dynamic> json) => Scenario(
    id: json.text('id'),
    title: json.text('title'),
    description: json.text('desc'),
    createdAt: json.day('createdAt'),
    hypotheses: [for (final h in json.records('hyps')) _hypothesisFromJson(h)],
  );

  static Map<String, dynamic> toJson(Scenario scenario) => {
    'id': scenario.id,
    'title': scenario.title,
    'desc': scenario.description,
    'createdAt': encodeDay(scenario.createdAt),
    'hyps': [for (final h in scenario.hypotheses) _hypothesisToJson(h)],
  };

  static Hypothesis _hypothesisFromJson(Map<String, dynamic> json) => Hypothesis(
    recurrenceId: json.optionalText('recId'),
    name: json.text('name'),
    categoryKey: json.text('cat'),
    frequency: Frequency.fromStorageKey(json.text('freq')),
    oldAmount: json.decimal('oldAmount'),
    newAmount: json.decimal('newAmount'),
    isKept: json.flag('keep', fallback: true),
  );

  static Map<String, dynamic> _hypothesisToJson(Hypothesis hypothesis) => {
    'recId': hypothesis.recurrenceId,
    'name': hypothesis.name,
    'cat': hypothesis.categoryKey,
    'freq': hypothesis.frequency.storageKey,
    'oldAmount': hypothesis.oldAmount,
    'newAmount': hypothesis.newAmount,
    'keep': hypothesis.isKept,
  };
}
