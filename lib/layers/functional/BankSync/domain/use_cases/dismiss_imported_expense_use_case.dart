import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_deletion_listener.dart';

import '../entities/bank_link.dart';
import '../gateways/bank_link_gateway.dart';

class DismissImportedExpenseUseCase implements ExpenseDeletionListener {
  DismissImportedExpenseUseCase(this._links);

  final BankLinkGateway _links;

  @override
  Future<void> call(Expense deleted) async {
    final links = _links.all();
    final created = links.where((link) => link.expenseId == deleted.id && link.kind == BankLinkKind.created).toList();
    if (created.isEmpty) return;
    for (final link in created) {
      await _links.dismiss(link.transactionId);
    }
    await _links.saveAll(links.where((link) => !created.contains(link)).toList());
  }
}
