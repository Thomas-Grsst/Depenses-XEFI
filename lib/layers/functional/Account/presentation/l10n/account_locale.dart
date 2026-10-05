mixin AccountLocale {
  static const title = 'account.title';
  static const back = 'account.back';
  static const close = 'account.close';
  static const balanceField = 'account.balanceField';
  static const balanceHint = 'account.balanceHint';
  static const balanceHelp = 'account.balanceHelp';
  static const incomeField = 'account.incomeField';
  static const incomeHint = 'account.incomeHint';
  static const payDayLabel = 'account.payDayLabel';
  static const payDayLabelShort = 'account.payDayLabelShort';
  static const everyMonth = 'account.everyMonth';
  static const shortMonthsNote = 'account.shortMonthsNote';
  static const previousDay = 'account.previousDay';
  static const nextDay = 'account.nextDay';
  static const save = 'account.save';
  static const endOfMonthTitle = 'account.endOfMonthTitle';
  static const onAccountToday = 'account.onAccountToday';
  static const salary = 'account.salary';
  static const upcomingRecurring = 'account.upcomingRecurring';
  static const noRecurrenceLeft = 'account.noRecurrenceLeft';
  static const recurrenceTimes = 'account.recurrenceTimes';
  static const namesSeparator = 'account.namesSeparator';
  static const futureNoted = 'account.futureNoted';
  static const estimatedDaily = 'account.estimatedDaily';
  static const dailyEstimateOne = 'account.dailyEstimateOne';
  static const dailyEstimateOther = 'account.dailyEstimateOther';
  static const estimatedOn = 'account.estimatedOn';
  static const recalculatedNote = 'account.recalculatedNote';
  static const correct = 'account.correct';
  static const onYourAccount = 'account.onYourAccount';
  static const onYourAccountShort = 'account.onYourAccountShort';
  static const enterBalance = 'account.enterBalance';
  static const enterBalanceLink = 'account.enterBalanceLink';
  static const endOfMonthApprox = 'account.endOfMonthApprox';
  static const paydayAndIncome = 'account.paydayAndIncome';
  static const paydayDivider = 'account.paydayDivider';
  static const weekdayAndDay = 'account.weekdayAndDay';
  static const detail = 'account.detail';

  static const Map<String, dynamic> fr = {
    title: 'Mon compte',
    back: 'Retour',
    close: 'Fermer',
    balanceField: 'Solde actuel du compte',
    balanceHint: 'Ex. 1 250,40',
    balanceHelp:
        'Ce qu’il y a sur ton compte aujourd’hui. Ensuite l’app le tient à jour : − tes dépenses, + ton salaire.',
    incomeField: 'Salaire mensuel',
    incomeHint: 'Ex. 2 400',
    payDayLabel: 'Le salaire tombe le…',
    payDayLabelShort: 'JOUR DE PAIE',
    everyMonth: 'de chaque mois',
    shortMonthsNote: 'Les mois plus courts, le dernier jour du mois.',
    previousDay: '−',
    nextDay: '+',
    save: 'Enregistrer',
    endOfMonthTitle: 'Fin de %a',
    onAccountToday: 'Sur ton compte aujourd’hui',
    salary: 'Salaire',
    upcomingRecurring: 'Dépenses récurrentes à venir',
    noRecurrenceLeft: 'Aucune d’ici la fin du mois',
    recurrenceTimes: '%a ×%a',
    namesSeparator: ', ',
    futureNoted: 'Dépenses déjà notées pour plus tard',
    estimatedDaily: 'Dépenses courantes estimées',
    dailyEstimateOne: '≈ %a/jour × %a jour (ton rythme habituel)',
    dailyEstimateOther: '≈ %a/jour × %a jours (ton rythme habituel)',
    estimatedOn: 'Estimé au %a %a',
    recalculatedNote: 'Recalculé à chaque dépense : quand tu dépenses, ton solde baisse tout de suite, et le rythme estimé s’ajuste à ta façon de dépenser.',
    correct: 'Corriger mon solde ou mon salaire',
    onYourAccount: 'Sur ton compte',
    onYourAccountShort: 'SUR LE COMPTE',
    enterBalance: 'Indique ton solde actuel',
    enterBalanceLink: 'Indiquer le solde de mon compte →',
    endOfMonthApprox: 'Fin de mois ≈ **%a**',
    paydayAndIncome: 'Salaire %a · %a',
    paydayDivider: '  ·  ',
    weekdayAndDay: '%a %a',
    detail: 'Détail ›',
  };
}
