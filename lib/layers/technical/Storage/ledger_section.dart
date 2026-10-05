enum LedgerSection {
  settings('settings'),
  expenses('expenses'),
  recurrences('recs'),
  envelopes('envelopes'),
  labelEnvelopes('labelEnvs'),
  goals('goals'),
  scenarios('sims'),
  labels('labels'),
  categories('cats');

  const LedgerSection(this.key);

  final String key;
}
