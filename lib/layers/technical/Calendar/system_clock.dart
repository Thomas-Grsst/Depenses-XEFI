import 'calendar_day.dart';
import 'clock.dart';

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime today() => DateTime.now().dateOnly;
}
