import 'package:depenses/layers/technical/Storage/document_store.dart';

import '../../domain/entities/appearance_settings.dart';
import '../../domain/entities/color_palette.dart';
import '../../domain/entities/theme_preference.dart';
import '../../domain/entities/visual_style.dart';
import '../../domain/gateways/appearance_gateway.dart';

class AppearanceGatewayImpl implements AppearanceGateway {
  AppearanceGatewayImpl(this._store);

  final DocumentStore _store;

  @override
  AppearanceSettings get() {
    final json = _store.readSettings();
    return AppearanceSettings(
      themePreference: ThemePreference.fromStorageKey(json['themeMode'] as String?),
      style: VisualStyle.fromStorageKey(json['style'] as String?),
      palette: ColorPalette.fromStorageKey(json['palette'] as String?),
    );
  }

  @override
  Future<void> save(AppearanceSettings settings) => _store.mergeSettings({
    'themeMode': settings.themePreference.storageKey,
    'style': settings.style.storageKey,
    'palette': settings.palette.storageKey,
  });
}
