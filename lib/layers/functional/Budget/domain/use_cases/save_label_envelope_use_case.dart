import '../entities/label_envelope.dart';
import 'add_label_envelope_use_case.dart';
import 'update_label_envelope_use_case.dart';

class SaveLabelEnvelopeUseCase {
  SaveLabelEnvelopeUseCase(this._add, this._update);

  final AddLabelEnvelopeUseCase _add;
  final UpdateLabelEnvelopeUseCase _update;

  Future<bool> call({
    LabelEnvelope? existing,
    required String name,
    required String fallbackName,
    required String label,
    required double amount,
  }) async {
    if (amount <= 0 || label.isEmpty) return false;
    final trimmed = name.trim();
    final resolvedName = trimmed.isEmpty ? fallbackName : trimmed;
    if (existing == null) {
      await _add(name: resolvedName, label: label, amount: amount);
    } else {
      await _update(existing.copyWith(name: resolvedName, label: label, amount: amount));
    }
    return true;
  }
}
