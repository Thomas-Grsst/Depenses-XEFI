const _technicalPrefixes = [
  ['PAIEMENT', 'PAR', 'CARTE'],
  ['PRLV', 'SEPA'],
  ['VIR', 'SEPA'],
  ['PRLV'],
  ['CARTE'],
  ['ACHAT'],
  ['CB'],
];

final _maskedCard = RegExp(r'\bCARTE\s+X*\d{4}\b|\bX+\d{4}\b|\*{2,}\d{4}\b');
final _dateToken = RegExp(r'^\d{1,2}/\d{1,2}(/\d{2,4})?$');
final _longNumberToken = RegExp(r'^\d{5,}$');
final _edgePunctuation = RegExp(r"^[-.,:;'/]+|[-.,:;'/]+$");

class BankLabelCleaner {
  const BankLabelCleaner();

  static const unnamed = 'Opération bancaire';

  String clean(String rawLabel) {
    final upper = rawLabel.toUpperCase().replaceAll(_maskedCard, ' ').replaceAll('*', ' ');
    final tokens = upper.split(RegExp(r'\s+')).where((token) => token.isNotEmpty).toList();
    for (final segment in _segments(tokens)) {
      final merchant = _withoutPrefixes(segment);
      if (merchant.isNotEmpty) return _titleCase(merchant);
    }
    final fallback = rawLabel.trim();
    return fallback.isEmpty ? unnamed : _titleCase(fallback.split(RegExp(r'\s+')));
  }

  Iterable<List<String>> _segments(List<String> tokens) sync* {
    var current = <String>[];
    for (final token in tokens) {
      if (_isNoise(token)) {
        if (current.isNotEmpty) yield current;
        current = [];
      } else {
        current.add(token);
      }
    }
    if (current.isNotEmpty) yield current;
  }

  bool _isNoise(String token) => _dateToken.hasMatch(token) || _longNumberToken.hasMatch(token) || token.contains('/');

  List<String> _withoutPrefixes(List<String> segment) {
    var remaining = segment;
    var hasStripped = true;
    while (hasStripped && remaining.isNotEmpty) {
      hasStripped = false;
      for (final prefix in _technicalPrefixes) {
        if (_startsWith(remaining, prefix)) {
          remaining = remaining.sublist(prefix.length);
          hasStripped = true;
          break;
        }
      }
    }
    return [
      for (final token in remaining)
        if (token.replaceAll(_edgePunctuation, '').isNotEmpty) token.replaceAll(_edgePunctuation, ''),
    ];
  }

  bool _startsWith(List<String> tokens, List<String> prefix) {
    if (tokens.length < prefix.length) return false;
    for (var index = 0; index < prefix.length; index++) {
      if (tokens[index] != prefix[index]) return false;
    }
    return true;
  }

  String _titleCase(List<String> words) => words.map(_capitalizeWord).join(' ');

  String _capitalizeWord(String word) => word.split('-').map(_capitalize).join('-');

  String _capitalize(String part) => part.isEmpty ? part : part[0].toUpperCase() + part.substring(1).toLowerCase();
}
