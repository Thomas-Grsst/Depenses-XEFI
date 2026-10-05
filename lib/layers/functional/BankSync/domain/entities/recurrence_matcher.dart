import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/recurrence.dart';
import 'package:depenses/layers/technical/TextMatching/normalize_for_matching.dart';

import 'bank_transaction.dart';
import 'recurrence_match.dart';

const recurrenceAmountTolerance = 0.03;
const recurrenceDayTolerance = 5;

class RecurrenceMatcher {
  const RecurrenceMatcher();

  RecurrenceMatch? match(BankTransaction transaction, Iterable<Recurrence> recurrences, {required String cleanedName}) {
    RecurrenceMatch? closest;
    for (final recurrence in recurrences) {
      final isClose = isCloseName(recurrence.name, cleanedName) || isCloseName(recurrence.name, transaction.rawLabel);
      final candidate = isClose ? _occurrenceMatch(transaction, recurrence) : null;
      if (candidate != null && (closest == null || candidate.distance < closest.distance)) closest = candidate;
    }
    return closest;
  }

  Expense? generatedExpenseFor(RecurrenceMatch match, Iterable<Expense> unlinkedExpenses) {
    Expense? closest;
    var closestGap = recurrenceDayTolerance + 1;
    for (final expense in unlinkedExpenses) {
      if (expense.recurrenceId != match.recurrence.id) continue;
      final gap = daysBetween(expense.date, match.occurrence);
      if (gap < closestGap) {
        closest = expense;
        closestGap = gap;
      }
    }
    return closest;
  }

  RecurrenceMatch? _occurrenceMatch(BankTransaction transaction, Recurrence recurrence) {
    if (recurrence.amount <= 0) return null;
    final amountGap = (transaction.amount - recurrence.amount).abs() / recurrence.amount;
    if (amountGap > recurrenceAmountTolerance) return null;
    final date = transaction.date;
    final window = recurrence.occurrences(
      DateTime(date.year, date.month, date.day - recurrenceDayTolerance),
      DateTime(date.year, date.month, date.day + recurrenceDayTolerance),
    );
    RecurrenceMatch? closest;
    for (final occurrence in window) {
      final distance = daysBetween(occurrence, date) / recurrenceDayTolerance + amountGap / recurrenceAmountTolerance;
      if (closest == null || distance < closest.distance) {
        closest = RecurrenceMatch(recurrence: recurrence, occurrence: occurrence, distance: distance);
      }
    }
    return closest;
  }

  static bool isCloseName(String first, String second) {
    final a = normalizeForMatching(first);
    final b = normalizeForMatching(second);
    if (a.isEmpty || b.isEmpty) return false;
    return a.split(' ').first == b.split(' ').first || a.contains(b) || b.contains(a);
  }

  static int daysBetween(DateTime first, DateTime second) => DateTime.utc(
    first.year,
    first.month,
    first.day,
  ).difference(DateTime.utc(second.year, second.month, second.day)).inDays.abs();
}
