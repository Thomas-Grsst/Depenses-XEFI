abstract final class PayDay {
  static const last = 31;
  static const lastInEveryMonth = 28;

  static int shift(int payDay, int delta) => ((payDay - 1 + delta) % last + last) % last + 1;

  static bool fallsBackInShortMonths(int payDay) => payDay > lastInEveryMonth;
}
