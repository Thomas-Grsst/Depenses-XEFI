import 'package:depenses/layers/technical/Calendar/clock.dart';

class FixedClock implements Clock {
  FixedClock(this.current);

  DateTime current;

  @override
  DateTime today() => DateTime(current.year, current.month, current.day);
}
