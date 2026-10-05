import '../gateways/profile_gateway.dart';

class SaveProfileNameUseCase {
  SaveProfileNameUseCase(this._profile);

  final ProfileGateway _profile;

  Future<void> call(String name) => _profile.saveName(name.trim());
}
