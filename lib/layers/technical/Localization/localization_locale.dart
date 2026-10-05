mixin LocalizationLocale {
  static const today = 'localization.today';
  static const yesterday = 'localization.yesterday';
  static const tomorrow = 'localization.tomorrow';
  static const firstDayOfMonth = 'localization.firstDayOfMonth';
  static const yesterdayWithDate = 'localization.yesterdayWithDate';
  static const everyWeekOn = 'localization.everyWeekOn';
  static const everyMonthOn = 'localization.everyMonthOn';
  static const everyYearOn = 'localization.everyYearOn';
  static const currencySymbol = 'localization.currencySymbol';

  static const Map<String, dynamic> fr = {
    today: 'Aujourd’hui',
    yesterday: 'Hier',
    tomorrow: 'Demain',
    firstDayOfMonth: '1er',
    yesterdayWithDate: 'Hier · %a',
    everyWeekOn: 'Chaque semaine · %a',
    everyMonthOn: 'Tous les mois · le %a',
    everyYearOn: 'Chaque année · %a',
    currencySymbol: '€',
  };
}
