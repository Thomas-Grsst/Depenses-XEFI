import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:equatable/equatable.dart';

import 'expense.dart';

class DescribedExpense extends Equatable {
  const DescribedExpense({required this.expense, required this.category, required this.look});

  final Expense expense;
  final Category category;
  final MerchantLook look;

  @override
  List<Object?> get props => [expense, category, look];
}
