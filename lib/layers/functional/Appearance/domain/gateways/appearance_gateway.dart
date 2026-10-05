import '../entities/appearance_settings.dart';

abstract class AppearanceGateway {
  AppearanceSettings get();

  Future<void> save(AppearanceSettings settings);
}
