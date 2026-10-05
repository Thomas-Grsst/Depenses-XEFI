import '../gateways/profile_gateway.dart';

class GetProfileNameUseCase {
  GetProfileNameUseCase(this._profile);

  final ProfileGateway _profile;

  String call() => _profile.name();
}
