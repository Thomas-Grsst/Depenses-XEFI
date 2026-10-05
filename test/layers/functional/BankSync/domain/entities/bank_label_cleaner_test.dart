import 'package:depenses/layers/functional/BankSync/domain/entities/bank_label_cleaner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const cleaner = BankLabelCleaner();

  final cases = {
    'CB CARREFOUR 03/10 PARIS 12': 'Carrefour',
    'PRLV SEPA FREE MOBILE': 'Free Mobile',
    'CARREFOUR MARKET': 'Carrefour Market',
    'CARTE X1234 03/10 CARREFOUR MARKET': 'Carrefour Market',
    'PAIEMENT PAR CARTE 031025 LECLERC DRIVE': 'Leclerc Drive',
    'ACHAT CB AMAZON 02/10/25 LUXEMBOURG': 'Amazon',
    'CB*SNCF INTERNET': 'Sncf Internet',
    'VIR SEPA LOYER OCTOBRE': 'Loyer Octobre',
    'PRLV EDF ECH/031025 REF 12345678': 'Edf',
    'CARTE 4821 BOULANGERIE   DU  COIN': 'Boulangerie Du Coin',
    'BOULANGERIE MARIE 75011 PARIS': 'Boulangerie Marie',
    'CB PICARD-SURGELES 12/09': 'Picard-Surgeles',
    'PHARMACIE CENTRALE ****9876': 'Pharmacie Centrale',
    'MONOPRIX': 'Monoprix',
  };

  for (final entry in cases.entries) {
    test('cleans "${entry.key}" into "${entry.value}"', () => expect(cleaner.clean(entry.key), entry.value));
  }

  test('keeps the raw label in title case when only technical tokens remain', () {
    expect(cleaner.clean('CB 03/10'), 'Cb 03/10');
  });

  test('names an empty label as a bank operation', () {
    expect(cleaner.clean('   '), BankLabelCleaner.unnamed);
  });
}
