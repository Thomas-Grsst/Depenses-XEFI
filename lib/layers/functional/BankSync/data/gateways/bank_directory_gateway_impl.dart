import 'package:depenses/layers/technical/OpenBanking/dto/aspsp_dto.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_client.dart';

import '../../domain/entities/bank.dart';
import '../../domain/gateways/bank_directory_gateway.dart';

class BankDirectoryGatewayImpl implements BankDirectoryGateway {
  BankDirectoryGatewayImpl(this._client);

  final EnableBankingClient _client;

  @override
  bool isAvailable() => _client.isConfigured;

  @override
  Future<List<Bank>> banks(String country) async => [
    for (final aspsp in await _client.listBanks(country: country)) _toBank(aspsp),
  ];

  static Bank _toBank(AspspDto aspsp) {
    final validity = aspsp.maximumConsentValidity;
    return Bank(
      name: aspsp.name,
      country: aspsp.country,
      logoUrl: aspsp.logoUrl,
      maximumConsentValidity: validity == null ? null : Duration(seconds: validity),
    );
  }
}
