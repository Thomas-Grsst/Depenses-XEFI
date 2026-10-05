import '../entities/visual_style.dart';
import '../gateways/appearance_gateway.dart';

class ChooseVisualStyleUseCase {
  ChooseVisualStyleUseCase(this._appearance);

  final AppearanceGateway _appearance;

  Future<void> call(VisualStyle style) => _appearance.save(_appearance.get().copyWith(style: style));
}
