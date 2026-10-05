import 'package:bloc_test/bloc_test.dart';
import 'package:depenses/layers/functional/BankSync/domain/entities/balance_gap.dart';
import 'package:depenses/layers/functional/BankSync/presentation/cubit/bank_balance_cubit.dart';
import 'package:depenses/layers/functional/BankSync/presentation/cubit/bank_balance_state.dart';
import 'package:depenses/layers/technical/Storage/ledger_section.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/in_memory_document_store.dart';
import '../../support/bank_balance_fakes.dart';

void main() {
  const gap = BalanceGap(bankBalance: 1180.50, appBalance: 1237);
  const aligned = BalanceGap(bankBalance: 1180.50, appBalance: 1180.50);
  late FakeGetBalanceGap gaps;
  late FakeAlignBalanceOnBank align;
  late InMemoryDocumentStore changes;

  setUp(() {
    gaps = FakeGetBalanceGap(gap);
    align = FakeAlignBalanceOnBank(gaps);
    changes = InMemoryDocumentStore();
  });
  tearDown(() => changes.dispose());

  BankBalanceCubit build() => BankBalanceCubit(gaps, align, changes);

  test('loading exposes a gap worth aligning', () {
    final cubit = build();
    addTearDown(cubit.close);

    expect(cubit.state, const BankBalanceState(gap: gap));
    expect(cubit.state.isWorthAligning, isTrue);
  });

  test('without bank balance nothing is offered', () {
    gaps.gap = null;
    final cubit = build();
    addTearDown(cubit.close);

    expect(cubit.state.gap, isNull);
    expect(cubit.state.isWorthAligning, isFalse);
  });

  test('a ledger change reloads the gap', () async {
    final cubit = build();
    addTearDown(cubit.close);

    gaps.gap = null;
    await changes.write(LedgerSection.bankAccounts, const []);

    expect(cubit.state.gap, isNull);
  });

  blocTest<BankBalanceCubit, BankBalanceState>(
    'using the bank balance aligns the app and hides the offer',
    build: build,
    act: (cubit) => cubit.align(),
    expect: () => const [BankBalanceState(gap: gap, isAligning: true), BankBalanceState(gap: aligned)],
    verify: (cubit) {
      expect(align.calls, 1);
      expect(cubit.state.isWorthAligning, isFalse);
    },
  );

  blocTest<BankBalanceCubit, BankBalanceState>(
    'a gap not worth aligning is never aligned',
    setUp: () => gaps.gap = const BalanceGap(bankBalance: 1236.20, appBalance: 1237),
    build: build,
    act: (cubit) => cubit.align(),
    expect: () => const <BankBalanceState>[],
    verify: (_) => expect(align.calls, 0),
  );
}
