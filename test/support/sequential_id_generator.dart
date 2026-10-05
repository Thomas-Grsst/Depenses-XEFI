import 'package:depenses/layers/technical/Storage/id_generator.dart';

class SequentialIdGenerator implements IdGenerator {
  SequentialIdGenerator([this.prefix = 'id']);

  final String prefix;
  int _next = 1;

  @override
  String next() => '$prefix${_next++}';
}
