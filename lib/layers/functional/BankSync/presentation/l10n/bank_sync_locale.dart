mixin BankSyncLocale {
  static const title = 'bankSync.title';
  static const back = 'bankSync.back';
  static const notConfiguredTitle = 'bankSync.notConfiguredTitle';
  static const notConfiguredHelp = 'bankSync.notConfiguredHelp';
  static const notConfiguredCommand = 'bankSync.notConfiguredCommand';
  static const linkPrompt = 'bankSync.linkPrompt';
  static const linkBank = 'bankSync.linkBank';
  static const linkAnother = 'bankSync.linkAnother';
  static const synchronizeNow = 'bankSync.synchronizeNow';
  static const synchronizing = 'bankSync.synchronizing';
  static const linkedAccounts = 'bankSync.linkedAccounts';
  static const validUntil = 'bankSync.validUntil';
  static const expiredOn = 'bankSync.expiredOn';
  static const accessExpired = 'bankSync.accessExpired';
  static const lastSync = 'bankSync.lastSync';
  static const neverSynced = 'bankSync.neverSynced';
  static const renewAccess = 'bankSync.renewAccess';
  static const unlink = 'bankSync.unlink';
  static const unlinkTitle = 'bankSync.unlinkTitle';
  static const unlinkMessage = 'bankSync.unlinkMessage';
  static const unlinkConfirm = 'bankSync.unlinkConfirm';
  static const cancel = 'bankSync.cancel';
  static const reportSeparator = 'bankSync.reportSeparator';
  static const failureExpired = 'bankSync.failureExpired';
  static const failureUnavailable = 'bankSync.failureUnavailable';
  static const failureNotConfigured = 'bankSync.failureNotConfigured';
  static const failureBrowser = 'bankSync.failureBrowser';
  static const pickerTitle = 'bankSync.pickerTitle';
  static const searchLabel = 'bankSync.searchLabel';
  static const searchHint = 'bankSync.searchHint';
  static const loadingBanks = 'bankSync.loadingBanks';
  static const noBankFound = 'bankSync.noBankFound';
  static const retry = 'bankSync.retry';
  static const opening = 'bankSync.opening';
  static const awaitingAuthorization = 'bankSync.awaitingAuthorization';
  static const returnToApp = 'bankSync.returnToApp';
  static const pasteLabel = 'bankSync.pasteLabel';
  static const pasteHint = 'bankSync.pasteHint';
  static const pasteHelp = 'bankSync.pasteHelp';
  static const pasteInvalid = 'bankSync.pasteInvalid';
  static const pasteConfirm = 'bankSync.pasteConfirm';
  static const callbackTitle = 'bankSync.callbackTitle';
  static const completing = 'bankSync.completing';
  static const linkedOne = 'bankSync.linkedOne';
  static const linkedOther = 'bankSync.linkedOther';
  static const cancelled = 'bankSync.cancelled';
  static const rejected = 'bankSync.rejected';
  static const backToBank = 'bankSync.backToBank';
  static const bankBalance = 'bankSync.bankBalance';
  static const useBankBalance = 'bankSync.useBankBalance';

  static const Map<String, dynamic> fr = {
    title: 'Ma banque',
    back: 'Retour',
    notConfiguredTitle: 'Synchronisation bancaire non configurée',
    notConfiguredHelp:
        'Renseigne ton identifiant d’application et ta clé Enable Banking dans config/enable_banking.json, '
        'puis relance l’app avec :',
    notConfiguredCommand: '--dart-define-from-file=config/enable_banking.json',
    linkPrompt: 'Relie ton compte pour importer tes dépenses automatiquement. Seules tes opérations transitent par Enable Banking.',
    linkBank: 'Relier ma banque',
    linkAnother: 'Relier un autre compte',
    synchronizeNow: 'Synchroniser maintenant',
    synchronizing: 'Synchronisation…',
    linkedAccounts: 'Comptes reliés',
    validUntil: 'Accès valable jusqu’au %a',
    expiredOn: 'Accès expiré depuis le %a',
    accessExpired: 'Accès à ta banque expiré',
    lastSync: 'Dernière synchro : %a',
    neverSynced: 'Jamais synchronisé',
    renewAccess: 'Renouveler l’accès',
    unlink: 'Délier',
    unlinkTitle: 'Délier ce compte ?',
    unlinkMessage: 'L’accès à %a sera révoqué. Les dépenses déjà importées sont conservées.',
    unlinkConfirm: 'Délier',
    cancel: 'Annuler',
    reportSeparator: ', ',
    failureExpired: 'Accès à ta banque expiré. Renouvelle l’accès pour continuer.',
    failureUnavailable: 'Ta banque ne répond pas pour le moment. Rien n’est perdu, réessaie plus tard.',
    failureNotConfigured: 'Synchronisation bancaire non configurée',
    failureBrowser: 'Impossible d’ouvrir le navigateur pour l’autorisation.',
    pickerTitle: 'Choisis ta banque',
    searchLabel: 'Rechercher',
    searchHint: 'Ex. Crédit Agricole',
    loadingBanks: 'Chargement des banques…',
    noBankFound: 'Aucune banque ne correspond.',
    retry: 'Réessayer',
    opening: 'Ouverture de %a…',
    awaitingAuthorization: 'Autorise l’accès dans la fenêtre de %a, puis reviens ici.',
    returnToApp: 'C’est fait ! Tu peux revenir dans l’app Dépenses.',
    pasteLabel: 'Colle l’adresse de retour',
    pasteHint: 'https://…?code=…&state=…',
    pasteHelp: 'Si l’app ne s’est pas rouverte, copie l’adresse de la page affichée par ta banque et colle-la ici.',
    pasteInvalid: 'Cette adresse ne contient pas de code d’autorisation.',
    pasteConfirm: 'Valider',
    callbackTitle: 'Liaison bancaire',
    completing: 'Finalisation de la liaison…',
    linkedOne: '%a compte relié',
    linkedOther: '%a comptes reliés',
    cancelled: 'La liaison a été annulée. Aucun compte n’a été relié.',
    rejected: 'Cette autorisation ne correspond pas à ta demande. Recommence la liaison.',
    backToBank: 'Retour à Ma banque',
    bankBalance: 'Solde bancaire : %a',
    useBankBalance: 'Utiliser ce solde',
  };
}
