import 'package:depenses/layers/technical/Storage/json_reading.dart';

import '../../domain/entities/goal.dart';

abstract final class GoalModel {
  static Goal fromJson(Map<String, dynamic> json) => Goal(
    id: json.text('id'),
    name: json.text('name'),
    target: json.decimal('target'),
    saved: json.decimal('saved'),
    monthly: json.decimal('monthly'),
  );

  static Map<String, dynamic> toJson(Goal goal) => {
    'id': goal.id,
    'name': goal.name,
    'target': goal.target,
    'saved': goal.saved,
    'monthly': goal.monthly,
  };
}
