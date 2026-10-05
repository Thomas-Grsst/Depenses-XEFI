import 'package:depenses/layers/technical/Storage/document_store.dart';
import 'package:depenses/layers/technical/Storage/ledger_section.dart';

import '../../domain/gateways/authorization_state_gateway.dart';

const _pendingStateKey = 'pendingState';

class AuthorizationStateGatewayImpl implements AuthorizationStateGateway {
  AuthorizationStateGatewayImpl(this._store);

  final DocumentStore _store;

  Map<String, dynamic> get _settings =>
      Map<String, dynamic>.from(_store.read(LedgerSection.bankSettings) as Map? ?? const {});

  @override
  String? pending() => _settings[_pendingStateKey] as String?;

  @override
  Future<void> remember(String state) =>
      _store.write(LedgerSection.bankSettings, {..._settings, _pendingStateKey: state});

  @override
  Future<void> clear() => _store.write(LedgerSection.bankSettings, {..._settings}..remove(_pendingStateKey));
}
