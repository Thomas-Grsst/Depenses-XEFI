import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';

class SimulationHypothesisChoice {
  const SimulationHypothesisChoice.recurrence(Recurrence this.recurrence);

  const SimulationHypothesisChoice.newCharge() : recurrence = null;

  final Recurrence? recurrence;
}
