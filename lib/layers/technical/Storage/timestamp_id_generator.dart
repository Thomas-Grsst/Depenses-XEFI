import 'dart:math';

import 'id_generator.dart';

class TimestampIdGenerator implements IdGenerator {
  TimestampIdGenerator([Random? random]) : _random = random ?? Random();

  final Random _random;

  @override
  String next() => DateTime.now().microsecondsSinceEpoch.toRadixString(36) + _random.nextInt(1 << 20).toRadixString(36);
}
