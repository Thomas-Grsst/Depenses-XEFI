import '../entities/appearance_settings.dart';
import '../gateways/appearance_gateway.dart';

class GetAppearanceUseCase {
  GetAppearanceUseCase(this._appearance);

  final AppearanceGateway _appearance;

  AppearanceSettings call() => _appearance.get();
}
