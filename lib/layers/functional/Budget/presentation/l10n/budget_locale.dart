mixin BudgetLocale {
  static const title = 'budget.title';
  static const back = 'budget.back';
  static const close = 'budget.close';
  static const edit = 'budget.edit';
  static const introTitle = 'budget.introTitle';
  static const introBody = 'budget.introBody';
  static const defineEnvelopes = 'budget.defineEnvelopes';
  static const envelopesLabel = 'budget.envelopesLabel';
  static const heroSuffix = 'budget.heroSuffix';
  static const forecastWithMargin = 'budget.forecastWithMargin';
  static const marginOf = 'budget.marginOf';
  static const overrunOf = 'budget.overrunOf';
  static const monthEnvelopes = 'budget.monthEnvelopes';
  static const outOf = 'budget.outOf';
  static const trailingOutOf = 'budget.trailingOutOf';
  static const usedPercent = 'budget.usedPercent';
  static const forecastWithMarginShort = 'budget.forecastWithMarginShort';
  static const marginShort = 'budget.marginShort';
  static const overrunShort = 'budget.overrunShort';
  static const simulate = 'budget.simulate';
  static const simulateExample = 'budget.simulateExample';
  static const noteUntrackedWithSpending = 'budget.noteUntrackedWithSpending';
  static const noteUntracked = 'budget.noteUntracked';
  static const noteOverspent = 'budget.noteOverspent';
  static const noteProjectedOverrun = 'budget.noteProjectedOverrun';
  static const noteOnTrack = 'budget.noteOnTrack';
  static const labelSectionShort = 'budget.labelSectionShort';
  static const labelSection = 'budget.labelSection';
  static const labelSubtitle = 'budget.labelSubtitle';
  static const newEnvelope = 'budget.newEnvelope';
  static const envelopeSheetTitle = 'budget.envelopeSheetTitle';
  static const envelopeQuestion = 'budget.envelopeQuestion';
  static const envelopeQuestionWithSpent = 'budget.envelopeQuestionWithSpent';
  static const amountPerMonth = 'budget.amountPerMonth';
  static const envelopeHint = 'budget.envelopeHint';
  static const save = 'budget.save';
  static const stopTracking = 'budget.stopTracking';
  static const envelopesSheetTitle = 'budget.envelopesSheetTitle';
  static const envelopesSheetIntro = 'budget.envelopesSheetIntro';
  static const noAmountHint = 'budget.noAmountHint';
  static const amountSuffix = 'budget.amountSuffix';
  static const newLabelEnvelopeTitle = 'budget.newLabelEnvelopeTitle';
  static const labelEnvelopeTitle = 'budget.labelEnvelopeTitle';
  static const labelEnvelopeIntro = 'budget.labelEnvelopeIntro';
  static const name = 'budget.name';
  static const nameHint = 'budget.nameHint';
  static const trackedLabel = 'budget.trackedLabel';
  static const labelAmountHint = 'budget.labelAmountHint';
  static const deleteEnvelope = 'budget.deleteEnvelope';
  static const defaultLabelEnvelopeName = 'budget.defaultLabelEnvelopeName';

  static const Map<String, dynamic> fr = {
    title: 'Budget · %a',
    back: 'Retour',
    close: 'Fermer',
    edit: 'Modifier',
    introTitle: 'Budget = enveloppes',
    introBody:
        '« Je prévois 400 € pour l’alimentation, 120 € pour mes sorties. » Fixe un montant par catégorie : '
        'l’app suit ton rythme et te prévient avant de dépasser.',
    defineEnvelopes: 'Définir mes enveloppes',
    envelopesLabel: 'Enveloppes',
    heroSuffix: '/ %a %a',
    forecastWithMargin: 'Prévu au %a : %a — %a',
    marginOf: 'marge de %a',
    overrunOf: 'dépassement de %a',
    monthEnvelopes: 'Tes enveloppes du mois',
    outOf: '/ %a',
    trailingOutOf: ' / %a',
    usedPercent: '%a utilisé',
    forecastWithMarginShort: 'Prévu au %a : %a · %a',
    marginShort: 'marge %a',
    overrunShort: 'dépasse de %a',
    simulate: 'Simuler un changement',
    simulateExample: '« Et si mon loyer augmentait ? »',
    noteUntrackedWithSpending: 'Pas de budget prévu · touche pour en définir un',
    noteUntracked: 'Touche pour définir un budget',
    noteOverspent: 'Dépassé de %a',
    noteProjectedOverrun: '%a au %a du mois · dépassement prévu ≈ %a',
    noteOnTrack: 'Prévu au %a : ≈ %a',
    labelSectionShort: 'Perso · par libellé',
    labelSection: 'Enveloppes perso · par libellé',
    labelSubtitle: 'libellé « %a »',
    newEnvelope: '+ Nouvelle enveloppe',
    envelopeSheetTitle: 'Budget %a',
    envelopeQuestion: 'Combien prévois-tu de dépenser par mois en %a ?',
    envelopeQuestionWithSpent: 'Combien prévois-tu de dépenser par mois en %a ?\nDéjà %a ce mois-ci.',
    amountPerMonth: 'Montant par mois',
    envelopeHint: 'Ex. 300',
    save: 'Enregistrer',
    stopTracking: 'Ne plus suivre cette catégorie',
    envelopesSheetTitle: 'Mon budget par catégorie',
    envelopesSheetIntro:
        'Combien prévois-tu de dépenser par mois dans chaque catégorie ? Laisse vide pour ne pas suivre.',
    noAmountHint: '—',
    amountSuffix: ' %a',
    newLabelEnvelopeTitle: 'Nouvelle enveloppe',
    labelEnvelopeTitle: 'Enveloppe',
    labelEnvelopeIntro:
        'Une enveloppe perso suit toutes les dépenses qui portent un libellé, quelle que soit leur catégorie.',
    name: 'Nom',
    nameHint: 'Ex. Mes sorties',
    trackedLabel: 'Libellé suivi',
    labelAmountHint: 'Ex. 120',
    deleteEnvelope: 'Supprimer l’enveloppe',
    defaultLabelEnvelopeName: 'Libellé « %a »',
  };
}
