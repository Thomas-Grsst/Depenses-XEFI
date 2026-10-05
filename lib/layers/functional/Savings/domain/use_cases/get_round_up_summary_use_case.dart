import 'dart:math';

import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';

import '../entities/round_up_summary.dart';
import '../gateways/round_up_usage_gateway.dart';

class GetRoundUpSummaryUseCase {
  GetRoundUpSummaryUseCase(this._expenses, this._usage);

  final ExpenseGateway _expenses;
  final RoundUpUsageGateway _usage;

  RoundUpSummary call(DateTime month) {
    final total = _expenses.all().fold(0.0, (sum, e) => sum + e.roundUp);
    final used = _usage.used();
    return RoundUpSummary(
      total: total,
      thisMonth: _expenses.inMonth(month).fold(0.0, (sum, e) => sum + e.roundUp),
      available: max(0, total - used),
      used: used,
    );
  }
}
