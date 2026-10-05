mixin ForecastCompareLocale {
  static const back = 'forecast.compareBack';
  static const close = 'forecast.compareClose';
  static const title = 'forecast.compareTitle';
  static const compareWith = 'forecast.compareWith';
  static const versusReference = 'forecast.versusReference';
  static const toDateShort = 'forecast.toDateShort';
  static const wholeMonthShort = 'forecast.wholeMonthShort';
  static const toDate = 'forecast.toDate';
  static const wholeMonth = 'forecast.wholeMonth';
  static const empty = 'forecast.compareEmpty';
  static const thisMonth = 'forecast.thisMonth';
  static const ratioDown = 'forecast.ratioDown';
  static const ratioUp = 'forecast.ratioUp';
  static const referenceToDate = 'forecast.referenceToDate';
  static const referenceWholeMonth = 'forecast.referenceWholeMonth';
  static const referenceToDateLess = 'forecast.referenceToDateLess';
  static const referenceToDateMore = 'forecast.referenceToDateMore';
  static const referenceWholeMonthLess = 'forecast.referenceWholeMonthLess';
  static const referenceWholeMonthMore = 'forecast.referenceWholeMonthMore';
  static const newCategory = 'forecast.compareNewCategory';
  static const noChange = 'forecast.noChange';
  static const moveDetail = 'forecast.moveDetail';
  static const whyItMoves = 'forecast.whyItMoves';
  static const deltaInEuros = 'forecast.deltaInEuros';
  static const deltaInEurosShort = 'forecast.deltaInEurosShort';
  static const insightDrop = 'forecast.insightDrop';
  static const insightRise = 'forecast.insightRise';
  static const insightDropAndRise = 'forecast.insightDropAndRise';
  static const insightDropShort = 'forecast.insightDropShort';
  static const insightRiseShort = 'forecast.insightRiseShort';
  static const insightDropAndRiseShort = 'forecast.insightDropAndRiseShort';

  static const Map<String, dynamic> fr = {
    back: 'Retour',
    close: 'Fermer',
    title: 'Comparaison',
    compareWith: 'Comparer avec',
    versusReference: 'vs %a',
    toDateShort: 'AU %a',
    wholeMonthShort: 'MOIS ENTIER',
    toDate: 'À date (au %a)',
    wholeMonth: 'Mois entier',
    empty: 'Pas encore de dépenses en %a pour comparer. Reviens le mois prochain : tu verras ici ce qui a bougé, catégorie par catégorie.',
    thisMonth: 'Ce mois-ci',
    ratioDown: '↓ %a',
    ratioUp: '↑ %a',
    referenceToDate: '%a à la même date : %a · %a',
    referenceWholeMonth: '%a (mois entier) : %a · %a',
    referenceToDateLess: '%a à la même date : %a · soit %a de moins',
    referenceToDateMore: '%a à la même date : %a · soit %a de plus',
    referenceWholeMonthLess: '%a (mois entier) : %a · soit %a de moins',
    referenceWholeMonthMore: '%a (mois entier) : %a · soit %a de plus',
    newCategory: 'nouveau',
    noChange: '—',
    moveDetail: '%a · %a %a',
    whyItMoves: 'Pourquoi ça bouge',
    deltaInEuros: 'écart en €',
    deltaInEurosShort: 'ÉCART €',
    insightDrop: 'La baisse vient surtout de **%a** (%a).',
    insightRise: 'C’est **%a** qui grimpe le plus (%a).',
    insightDropAndRise: 'La baisse vient surtout de **%a** (%a). À l’inverse, c’est **%a** qui grimpe le plus (%a).',
    insightDropShort: 'La **baisse** vient surtout de %a (%a).',
    insightRiseShort: 'C’est **%a** qui grimpe le plus (%a).',
    insightDropAndRiseShort:
        'La **baisse** vient surtout de %a (%a). À l’inverse, c’est **%a** qui grimpe le plus (%a).',
  };
}
