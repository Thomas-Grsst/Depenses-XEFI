import 'package:depenses/layers/technical/Calendar/clock.dart';
import 'package:depenses/layers/technical/OpenBanking/dto/session_account_dto.dart';
import 'package:depenses/layers/technical/OpenBanking/dto/session_dto.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_client.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_errors.dart';
import 'package:depenses/layers/technical/Storage/secret_store.dart';

import '../../domain/entities/bank.dart';
import '../../domain/entities/linked_bank_account.dart';
import '../../domain/gateways/bank_authorization_gateway.dart';
import '../../domain/gateways/linked_account_gateway.dart';
import 'bank_session_key.dart';

const _defaultCountry = 'FR';
const _visibleIbanDigits = 4;

class BankAuthorizationGatewayImpl implements BankAuthorizationGateway {
  BankAuthorizationGatewayImpl(this._client, this._secrets, this._accounts, this._clock);

  final EnableBankingClient _client;
  final SecretStore _secrets;
  final LinkedAccountGateway _accounts;
  final Clock _clock;

  @override
  Future<Uri> start(
    Bank bank, {
    required String state,
    required String redirectUrl,
    required DateTime validUntil,
  }) async {
    final start = await _client.startAuthorization(
      bankName: bank.name,
      country: bank.country,
      validUntil: validUntil,
      state: state,
      redirectUrl: redirectUrl,
    );
    return start.url;
  }

  @override
  Future<List<LinkedBankAccount>> complete(String code) async {
    final session = await _client.createSession(code: code);
    final validUntil = session.validUntil ?? _clock.today().add(Bank.defaultConsentValidity);
    final accounts = [for (final account in session.accounts) _toAccount(session, account, validUntil)];
    for (final account in accounts) {
      await _secrets.write(bankSessionKey(account.uid), session.sessionId);
    }
    return accounts;
  }

  @override
  Future<void> revoke(LinkedBankAccount account) async {
    final sessionId = await _secrets.read(bankSessionKey(account.uid));
    if (sessionId == null || await _isSharedByAnotherAccount(sessionId, account.uid)) return;
    try {
      await _client.deleteSession(sessionId);
    } on BankAccessExpiredException {
      return;
    } on BankSyncNotConfiguredException {
      return;
    }
  }

  Future<bool> _isSharedByAnotherAccount(String sessionId, String uid) async {
    for (final other in _accounts.all()) {
      if (other.uid != uid && await _secrets.read(bankSessionKey(other.uid)) == sessionId) return true;
    }
    return false;
  }

  static LinkedBankAccount _toAccount(SessionDto session, SessionAccountDto account, DateTime validUntil) =>
      LinkedBankAccount(
        uid: account.uid,
        bankName: session.bankName ?? '',
        country: session.bankCountry ?? _defaultCountry,
        label: _labelOf(account),
        accessValidUntil: validUntil,
      );

  static String _labelOf(SessionAccountDto account) {
    final name = account.name;
    if (name != null && name.trim().isNotEmpty) return name.trim();
    final iban = account.iban;
    if (iban != null && iban.length > _visibleIbanDigits) {
      return '•••• ${iban.substring(iban.length - _visibleIbanDigits)}';
    }
    return account.uid;
  }
}
