import '../gateways/label_gateway.dart';

class GetLabelsUseCase {
  GetLabelsUseCase(this._labels);

  final LabelGateway _labels;

  List<String> call() => _labels.all();
}
