import '../entities/appearance_settings.dart';
import '../gateways/appearance_gateway.dart';

class SaveAppearanceUseCase {
  SaveAppearanceUseCase(this._appearance);

  final AppearanceGateway _appearance;

  Future<void> call(AppearanceSettings settings) => _appearance.save(settings);
}
