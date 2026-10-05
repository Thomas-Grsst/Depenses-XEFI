import 'package:depenses/layers/technical/Calendar/clock.dart';
import 'package:depenses/layers/technical/OpenBanking/authorization_state_generator.dart';

import '../entities/bank.dart';
import '../gateways/authorization_state_gateway.dart';
import '../gateways/bank_authorization_gateway.dart';

class StartBankAuthorizationUseCase {
  StartBankAuthorizationUseCase(this._authorization, this._pendingState, this._states, this._clock);

  final BankAuthorizationGateway _authorization;
  final AuthorizationStateGateway _pendingState;
  final AuthorizationStateGenerator _states;
  final Clock _clock;

  Future<Uri> call(Bank bank, {required String redirectUrl}) async {
    final state = _states.next();
    await _pendingState.remember(state);
    return _authorization.start(
      bank,
      state: state,
      redirectUrl: redirectUrl,
      validUntil: _clock.today().add(bank.consentValidity),
    );
  }
}
