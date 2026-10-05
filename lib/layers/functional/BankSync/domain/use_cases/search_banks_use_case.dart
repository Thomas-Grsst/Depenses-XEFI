import 'package:depenses/layers/technical/TextMatching/normalize_for_matching.dart';

import '../entities/bank.dart';

class SearchBanksUseCase {
  const SearchBanksUseCase();

  List<Bank> call(List<Bank> banks, String query) {
    final needle = normalizeForMatching(query);
    if (needle.isEmpty) return banks;
    return [
      for (final bank in banks)
        if (normalizeForMatching(bank.name).contains(needle)) bank,
    ];
  }
}
