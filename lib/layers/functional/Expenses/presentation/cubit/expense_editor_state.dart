import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/default_categories.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:depenses/layers/functional/Forecast/domain/entities/category_stats.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/frequency.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/expense_entry_outcome.dart';
import 'expense_editor_status.dart';
import 'expense_editor_target.dart';

class ExpenseEditorState extends Equatable {
  const ExpenseEditorState({
    required this.target,
    required this.today,
    required this.date,
    required this.categoryKey,
    required this.isRecurring,
    this.frequency = Frequency.month,
    this.name = '',
    this.amount,
    this.labels = const [],
    this.isCategoryTouched = false,
    this.knownLabels = const [],
    this.categories = const [],
    this.categoryStats,
    this.roundUpPreview = 0,
    this.look,
    this.nextOccurrence,
    this.status = ExpenseEditorStatus.editing,
    this.outcome,
  });

  final ExpenseEditorTarget target;
  final DateTime today;
  final DateTime date;
  final String categoryKey;
  final bool isRecurring;
  final Frequency frequency;
  final String name;
  final double? amount;
  final List<String> labels;
  final bool isCategoryTouched;
  final List<String> knownLabels;
  final List<Category> categories;
  final CategoryStats? categoryStats;
  final double roundUpPreview;
  final MerchantLook? look;
  final DateTime? nextOccurrence;
  final ExpenseEditorStatus status;
  final ExpenseEntryOutcome? outcome;

  bool get isEditing => target.expense != null || target.recurrence != null;

  bool get canSave => amount != null && status == ExpenseEditorStatus.editing;

  Category get category => categories.firstWhere((c) => c.key == categoryKey, orElse: () => defaultCategories.last);

  List<String> get allLabels => {...knownLabels, ...labels}.toList();

  ExpenseEditorState copyWith({
    DateTime? today,
    DateTime? date,
    String? categoryKey,
    bool? isRecurring,
    Frequency? frequency,
    String? name,
    double? Function()? amount,
    List<String>? labels,
    bool? isCategoryTouched,
    List<String>? knownLabels,
    List<Category>? categories,
    CategoryStats? categoryStats,
    double? roundUpPreview,
    MerchantLook? Function()? look,
    DateTime? Function()? nextOccurrence,
    ExpenseEditorStatus? status,
    ExpenseEntryOutcome? outcome,
  }) => ExpenseEditorState(
    target: target,
    today: today ?? this.today,
    date: date ?? this.date,
    categoryKey: categoryKey ?? this.categoryKey,
    isRecurring: isRecurring ?? this.isRecurring,
    frequency: frequency ?? this.frequency,
    name: name ?? this.name,
    amount: amount == null ? this.amount : amount(),
    labels: labels ?? this.labels,
    isCategoryTouched: isCategoryTouched ?? this.isCategoryTouched,
    knownLabels: knownLabels ?? this.knownLabels,
    categories: categories ?? this.categories,
    categoryStats: categoryStats ?? this.categoryStats,
    roundUpPreview: roundUpPreview ?? this.roundUpPreview,
    look: look == null ? this.look : look(),
    nextOccurrence: nextOccurrence == null ? this.nextOccurrence : nextOccurrence(),
    status: status ?? this.status,
    outcome: outcome ?? this.outcome,
  );

  @override
  List<Object?> get props => [
    target,
    today,
    date,
    categoryKey,
    isRecurring,
    frequency,
    name,
    amount,
    labels,
    isCategoryTouched,
    knownLabels,
    categories,
    categoryStats,
    roundUpPreview,
    look,
    nextOccurrence,
    status,
    outcome,
  ];
}
