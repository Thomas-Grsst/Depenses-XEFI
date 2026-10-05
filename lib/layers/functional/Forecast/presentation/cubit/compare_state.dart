import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/month_comparison.dart';

enum CompareStatus { loading, ready }

class CompareState extends Equatable {
  const CompareState({
    this.status = CompareStatus.loading,
    this.comparison,
    this.referenceMonth,
    this.isToDate = true,
    this.comparableMonths = const [],
    this.categories = const {},
  });

  final CompareStatus status;
  final MonthComparison? comparison;
  final DateTime? referenceMonth;
  final bool isToDate;
  final List<DateTime> comparableMonths;
  final Map<String, Category> categories;

  CompareState copyWith({
    CompareStatus? status,
    MonthComparison? comparison,
    DateTime? referenceMonth,
    bool? isToDate,
    List<DateTime>? comparableMonths,
    Map<String, Category>? categories,
  }) => CompareState(
    status: status ?? this.status,
    comparison: comparison ?? this.comparison,
    referenceMonth: referenceMonth ?? this.referenceMonth,
    isToDate: isToDate ?? this.isToDate,
    comparableMonths: comparableMonths ?? this.comparableMonths,
    categories: categories ?? this.categories,
  );

  @override
  List<Object?> get props => [status, comparison, referenceMonth, isToDate, comparableMonths, categories];
}
