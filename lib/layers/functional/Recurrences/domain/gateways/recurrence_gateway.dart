import '../entities/recurrence.dart';

abstract class RecurrenceGateway {
  List<Recurrence> all();

  Recurrence? byId(String? id);

  Future<void> add(Recurrence recurrence);

  Future<void> update(Recurrence recurrence);

  Future<void> delete(String id);

  Future<void> saveAll(List<Recurrence> recurrences);

  Future<void> reassignCategory({required String from, required String to});

  Future<void> clear();
}
