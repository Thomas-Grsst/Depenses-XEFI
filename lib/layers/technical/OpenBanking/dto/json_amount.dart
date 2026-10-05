double parseJsonAmount(Object? raw) => switch (raw) {
  final num value => value.toDouble(),
  final String value => double.parse(value),
  _ => throw FormatException('Unexpected amount: $raw'),
};

Map<String, dynamic> jsonObject(Object? raw) => Map<String, dynamic>.from(raw as Map? ?? const {});

List<Map<String, dynamic>> jsonObjects(Object? raw) => [
  for (final item in raw as List? ?? const []) Map<String, dynamic>.from(item as Map),
];

DateTime? parseJsonDate(Object? raw) => raw is String && raw.isNotEmpty ? DateTime.parse(raw) : null;
