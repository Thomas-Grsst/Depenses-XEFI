import 'package:equatable/equatable.dart';

import 'expense_kind_filter.dart';

class ExpenseQuery extends Equatable {
  const ExpenseQuery({this.kind = ExpenseKindFilter.all, this.categoryKey, this.text = ''});

  final ExpenseKindFilter kind;
  final String? categoryKey;
  final String text;

  ExpenseQuery copyWith({ExpenseKindFilter? kind, String? Function()? categoryKey, String? text}) => ExpenseQuery(
    kind: kind ?? this.kind,
    categoryKey: categoryKey == null ? this.categoryKey : categoryKey(),
    text: text ?? this.text,
  );

  @override
  List<Object?> get props => [kind, categoryKey, text];
}
