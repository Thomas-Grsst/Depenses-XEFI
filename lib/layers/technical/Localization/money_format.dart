import 'package:intl/intl.dart';

const _minusSign = '−';
const _euro = 'EUR';

class MoneyFormat {
  MoneyFormat(this.locale)
    : _cents = NumberFormat.simpleCurrency(locale: locale, name: _euro, decimalDigits: 2),
      _whole = NumberFormat.simpleCurrency(locale: locale, name: _euro, decimalDigits: 0),
      _plainCents = NumberFormat('#,##0.00', locale),
      _plainWhole = NumberFormat('#,##0', locale),
      _input = NumberFormat('0.00', locale),
      _percent = NumberFormat.percentPattern(locale);

  final String locale;
  final NumberFormat _cents;
  final NumberFormat _whole;
  final NumberFormat _plainCents;
  final NumberFormat _plainWhole;
  final NumberFormat _input;
  final NumberFormat _percent;

  String euros(double value) => _signed(value, _cents.format(_roundCents(value).abs()));

  String wholeEuros(double value) => _signed(value.round().toDouble(), _whole.format(value.round().abs()));

  String autoEuros(double value) => _hasCents(value) ? euros(value) : wholeEuros(value);

  String decimals(double value) => _signed(value, _plainCents.format(_roundCents(value).abs()));

  String wholeNumber(double value) => _signed(value.round().toDouble(), _plainWhole.format(value.round().abs()));

  String inputText(double value) => _input.format(value);

  String withSign(double value, String Function(double) format) {
    if (value.abs() < 0.005) return '±${format(0)}';
    return (value > 0 ? '+' : _minusSign) + format(value.abs());
  }

  String percent(double ratio) => _percent.format(ratio);

  String signedPercent(double ratio) {
    final rounded = (ratio * 100).round();
    if (rounded == 0) return _percent.format(0);
    return (rounded > 0 ? '+' : _minusSign) + _percent.format(rounded.abs() / 100);
  }

  double? parse(String input) {
    final cleaned = input.replaceAll(RegExp(r'[\s  €]'), '').replaceAll(',', '.');
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  static bool _hasCents(double value) => (value * 100).round() % 100 != 0;

  static double _roundCents(double value) => (value * 100).round() / 100;

  static String _signed(double value, String formatted) =>
      value < 0 && _roundCents(value) != 0 ? '$_minusSign$formatted' : formatted;
}
