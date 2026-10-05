import 'package:depenses/layers/functional/BankSync/data/gateways/bank_link_gateway_impl.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/bank_link.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/in_memory_document_store.dart';

void main() {
  const link = BankLink(
    transactionId: 'tx-1',
    expenseId: 'e1',
    accountUid: 'acc-1',
    kind: BankLinkKind.matched,
    wasPending: true,
  );

  test('stores links in the bankLinks section with their short keys', () async {
    final store = InMemoryDocumentStore();
    final gateway = BankLinkGatewayImpl(store);

    await gateway.saveAll(const [link]);

    expect(store.snapshot['bankLinks'], [
      {'tx': 'tx-1', 'expense': 'e1', 'account': 'acc-1', 'kind': 'matched', 'pending': true},
    ]);
    expect(gateway.all(), [link]);
  });

  test('reads a link stored without kind nor pending flag as a booked creation', () {
    final store = InMemoryDocumentStore({
      'bankLinks': [
        {'tx': 'tx-9', 'expense': 'e9', 'account': 'acc-1'},
      ],
    });

    final stored = BankLinkGatewayImpl(store).all().single;

    expect(stored.kind, BankLinkKind.created);
    expect(stored.wasPending, isFalse);
  });

  test('remembers each dismissed transaction once', () async {
    final store = InMemoryDocumentStore();
    final gateway = BankLinkGatewayImpl(store);

    await gateway.dismiss('tx-1');
    await gateway.dismiss('tx-2');
    await gateway.dismiss('tx-1');

    expect(gateway.dismissed(), {'tx-1', 'tx-2'});
    expect(store.snapshot['bankDismissed'], ['tx-1', 'tx-2']);
    expect(BankLinkGatewayImpl(InMemoryDocumentStore()).dismissed(), isEmpty);
  });
}
