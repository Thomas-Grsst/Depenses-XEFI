import '../shell/shell_tab.dart';

mixin AppLocale {
  static const title = 'app.title';
  static const addExpense = 'app.addExpense';
  static const homeTab = 'app.homeTab';
  static const expensesTab = 'app.expensesTab';
  static const recurrencesTab = 'app.recurrencesTab';
  static const profileTab = 'app.profileTab';

  static String tabLabel(ShellTab tab) => switch (tab) {
    ShellTab.home => homeTab,
    ShellTab.expenses => expensesTab,
    ShellTab.recurrences => recurrencesTab,
    ShellTab.profile => profileTab,
  };

  static const Map<String, dynamic> fr = {
    title: 'Dépenses',
    addExpense: 'Ajouter une dépense',
    homeTab: 'Accueil',
    expensesTab: 'Dépenses',
    recurrencesTab: 'Récurrences',
    profileTab: 'Profil',
  };
}
