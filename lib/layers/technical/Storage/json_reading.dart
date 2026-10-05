extension JsonReading on Map<String, dynamic> {
  double decimal(String key, {double fallback = 0}) => (this[key] as num?)?.toDouble() ?? fallback;

  double? optionalDecimal(String key) => (this[key] as num?)?.toDouble();

  int integer(String key, {int fallback = 0}) => (this[key] as num?)?.toInt() ?? fallback;

  String text(String key, {String fallback = ''}) => this[key] as String? ?? fallback;

  String? optionalText(String key) => this[key] as String?;

  bool flag(String key, {bool fallback = false}) => this[key] as bool? ?? fallback;

  List<String> strings(String key) => List<String>.from(this[key] as List? ?? const []);

  DateTime day(String key) => DateTime.parse(this[key] as String);

  DateTime? optionalDay(String key) {
    final raw = this[key] as String?;
    return raw == null ? null : DateTime.parse(raw);
  }

  List<Map<String, dynamic>> records(String key) => [
    for (final item in this[key] as List? ?? const []) Map<String, dynamic>.from(item as Map),
  ];
}

List<Map<String, dynamic>> jsonRecords(Object? raw) => [
  for (final item in raw as List? ?? const []) Map<String, dynamic>.from(item as Map),
];

String encodeDay(DateTime day) => day.toIso8601String().substring(0, 10);
