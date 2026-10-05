import '../entities/hypothesis.dart';
import '../entities/scenario.dart';
import 'create_scenario_use_case.dart';

class SaveScenarioUseCase {
  SaveScenarioUseCase(this._create);

  final CreateScenarioUseCase _create;

  Future<Scenario> call({
    required String title,
    required String description,
    required String fallbackTitle,
    required List<Hypothesis> hypotheses,
  }) {
    final trimmedTitle = title.trim();
    return _create(
      title: trimmedTitle.isEmpty ? fallbackTitle : trimmedTitle,
      description: description.trim(),
      hypotheses: hypotheses,
    );
  }
}
