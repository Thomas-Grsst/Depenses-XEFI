import 'package:depenses/layers/technical/OpenBanking/dto/balance_dto.dart';
import 'package:depenses/layers/technical/OpenBanking/enable_banking_client.dart';

import '../../domain/entities/bank_transaction.dart';
import '../../domain/entities/linked_bank_account.dart';
import '../../domain/gateways/bank_data_gateway.dart';
import '../models/bank_transaction_mapper.dart';

const _balancePreference = ['ITAV', 'CLAV', 'ITBD', 'CLBD'];

class BankDataGatewayImpl implements BankDataGateway {
  BankDataGatewayImpl(this._client);

  final EnableBankingClient _client;

  @override
  Future<List<BankTransaction>> transactions(LinkedBankAccount account, DateTime from) async {
    final transactions = <BankTransaction>[];
    final seenKeys = <String>{};
    String? continuationKey;
    do {
      final page = await _client.transactions(account.uid, from: from, continuationKey: continuationKey);
      transactions.addAll(page.transactions.map(BankTransactionMapper.fromDto).nonNulls);
      final nextKey = page.continuationKey;
      continuationKey = nextKey == null || nextKey.isEmpty ? null : nextKey;
    } while (continuationKey != null && seenKeys.add(continuationKey));
    return transactions;
  }

  @override
  Future<double?> balance(LinkedBankAccount account) async => preferredBalance(await _client.balances(account.uid));

  static double? preferredBalance(List<BalanceDto> balances) {
    for (final type in _balancePreference) {
      final match = balances.where((balance) => balance.type == type).firstOrNull;
      if (match != null) return match.amount;
    }
    return balances.firstOrNull?.amount;
  }
}
