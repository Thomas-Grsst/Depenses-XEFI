enum AppRoute {
  newExpense('/expenses/new'),
  editExpense('/expenses/edit'),
  newRecurrence('/recurrences/new'),
  editRecurrence('/recurrences/edit'),
  budget('/budget'),
  forecast('/forecast'),
  compare('/compare'),
  categories('/categories'),
  newCategory('/categories/new'),
  editCategory('/categories/edit'),
  editEnvelope('/budget/envelope'),
  account('/account'),
  roundUp('/round-up'),
  simulations('/simulations'),
  simulation('/simulation'),
  bankSync('/bank'),
  bankPicker('/bank/pick'),
  bankCallback('/bank-callback');

  const AppRoute(this.path);

  final String path;

  static AppRoute? fromPath(String? path) {
    final routePath = path == null ? null : Uri.tryParse(path)?.path ?? path;
    for (final route in values) {
      if (route.path == routePath) return route;
    }
    return null;
  }
}
