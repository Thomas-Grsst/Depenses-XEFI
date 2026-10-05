import 'package:depenses/layers/functional/Categories/domain/gateways/category_gateway.dart';
import 'package:depenses/layers/functional/Expenses/domain/entities/expense.dart';
import 'package:depenses/layers/functional/Expenses/domain/gateways/expense_gateway.dart';
import 'package:depenses/layers/technical/Storage/json_reading.dart';

const _header = 'date;nom;montant;categorie;libelles;recurrente';
const _separator = ';';
const _recurringYes = 'oui';
const _recurringNo = 'non';

class ExportExpensesCsvUseCase {
  ExportExpensesCsvUseCase(this._expenses, this._categories);

  final ExpenseGateway _expenses;
  final CategoryGateway _categories;

  String call() {
    final buffer = StringBuffer('$_header\n');
    final sorted = [..._expenses.all()]..sort((a, b) => a.date.compareTo(b.date));
    for (final expense in sorted) {
      buffer.writeln(_row(expense).join(_separator));
    }
    return buffer.toString();
  }

  List<String> _row(Expense expense) => [
    encodeDay(expense.date),
    _quoted(expense.name),
    expense.amount.toStringAsFixed(2).replaceAll('.', ','),
    _quoted(_categories.byKey(expense.categoryKey).name),
    _quoted(expense.labels.join(', ')),
    expense.isRecurring ? _recurringYes : _recurringNo,
  ];

  static String _quoted(String value) => '"${value.replaceAll('"', '""')}"';
}
