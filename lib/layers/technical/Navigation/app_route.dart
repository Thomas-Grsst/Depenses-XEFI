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
  simulation('/simulation');

  const AppRoute(this.path);

  final String path;

  static AppRoute? fromPath(String? path) {
    for (final route in values) {
      if (route.path == path) return route;
    }
    return null;
  }
}
