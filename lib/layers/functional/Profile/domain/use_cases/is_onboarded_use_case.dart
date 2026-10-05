import '../gateways/profile_gateway.dart';

class IsOnboardedUseCase {
  IsOnboardedUseCase(this._profile);

  final ProfileGateway _profile;

  bool call() => _profile.name().trim().isNotEmpty;
}
