import '../gateways/label_gateway.dart';

class AddLabelUseCase {
  AddLabelUseCase(this._labels);

  final LabelGateway _labels;

  Future<String?> call(String label) async {
    final trimmed = label.trim();
    if (trimmed.isEmpty) return null;
    await _labels.learn([trimmed]);
    return trimmed;
  }
}
