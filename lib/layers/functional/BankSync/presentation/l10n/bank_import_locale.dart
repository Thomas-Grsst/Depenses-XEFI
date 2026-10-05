mixin BankImportLocale {
  static const upToDate = 'bankImport.upToDate';
  static const createdOne = 'bankImport.createdOne';
  static const createdOther = 'bankImport.createdOther';
  static const updatedOne = 'bankImport.updatedOne';
  static const updatedOther = 'bankImport.updatedOther';
  static const matchedOne = 'bankImport.matchedOne';
  static const matchedOther = 'bankImport.matchedOther';
  static const removedOne = 'bankImport.removedOne';
  static const removedOther = 'bankImport.removedOther';
  static const accessExpired = 'bankImport.accessExpired';
  static const bankUnavailable = 'bankImport.bankUnavailable';
  static const rateLimited = 'bankImport.rateLimited';

  static const Map<String, dynamic> fr = {
    upToDate: 'Déjà à jour',
    createdOne: '%a dépense ajoutée',
    createdOther: '%a dépenses ajoutées',
    updatedOne: '%a dépense mise à jour',
    updatedOther: '%a dépenses mises à jour',
    matchedOne: '%a dépense rapprochée',
    matchedOther: '%a dépenses rapprochées',
    removedOne: '%a opération annulée retirée',
    removedOther: '%a opérations annulées retirées',
    accessExpired: 'Accès à ta banque expiré',
    bankUnavailable: 'Banque injoignable, réessaie plus tard',
    rateLimited: 'Trop de demandes à la banque, réessaie plus tard',
  };
}
