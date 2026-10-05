enum LedgerSection {
  settings('settings'),
  expenses('expenses'),
  recurrences('recs'),
  envelopes('envelopes'),
  labelEnvelopes('labelEnvs'),
  goals('goals'),
  scenarios('sims'),
  labels('labels'),
  categories('cats'),
  bankAccounts('bankAccounts'),
  bankLinks('bankLinks'),
  bankDismissed('bankDismissed'),
  bankSettings('bankSettings');

  const LedgerSection(this.key);

  final String key;
}
