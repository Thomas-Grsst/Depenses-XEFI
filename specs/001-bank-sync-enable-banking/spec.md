# Feature Specification: Synchronisation bancaire (Enable Banking)

**Feature Branch**: `001-bank-sync-enable-banking`

**Created**: 2026-10-05

**Status**: Draft

**Input**: User description: "Synchronisation bancaire via Enable Banking : l'utilisateur relie son compte bancaire (mode restreint gratuit, ses propres comptes), l'app importe les opérations bancaires et les transforme en dépenses (catégorie devinée, doublons évités, récurrences rattachées), et peut recaler le solde du compte sur le solde bancaire. Projet d'école, usage personnel ; les données peuvent transiter par Enable Banking."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Relier son compte bancaire (Priority: P1)

Depuis son profil, l'utilisateur choisit « Relier ma banque ». Il sélectionne sa banque dans une liste, est redirigé vers l'écran d'autorisation de sa banque, s'authentifie, puis revient dans l'app. Celle-ci affiche alors le compte relié : nom de la banque, libellé du compte et date d'expiration de l'autorisation.

**Why this priority**: Sans compte relié, aucune autre fonction de synchronisation n'est possible. C'est le socle de la fonctionnalité.

**Independent Test**: Relier un compte (banque de test du bac à sable ou vraie banque en mode restreint) et vérifier que le compte apparaît comme relié dans le profil, avec sa date d'expiration.

**Acceptance Scenarios**:

1. **Given** aucun compte relié, **When** l'utilisateur choisit sa banque puis valide l'autorisation chez sa banque, **Then** l'app affiche le compte relié et la date jusqu'à laquelle l'accès est valable.
2. **Given** l'utilisateur annule ou refuse l'autorisation chez sa banque, **When** il revient dans l'app, **Then** aucun compte n'est relié et un message explique que la liaison a été annulée.
3. **Given** un compte relié, **When** l'utilisateur choisit « Délier ma banque », **Then** l'accès est révoqué, le compte n'apparaît plus comme relié, et les dépenses déjà importées sont conservées.

---

### User Story 2 - Importer les opérations en dépenses (Priority: P1)

Une fois le compte relié, l'utilisateur lance une synchronisation, ou elle se lance à l'ouverture de l'app. Les opérations de débit récentes sont importées comme dépenses : le nom est tiré du libellé bancaire, le montant et la date viennent de l'opération, et la catégorie est devinée comme pour une saisie manuelle. Une nouvelle synchronisation ne crée jamais deux fois la même dépense.

**Why this priority**: C'est la valeur principale de la fonctionnalité : ne plus saisir chaque dépense à la main.

**Independent Test**: Relier un compte qui a des opérations, synchroniser, puis vérifier que chaque débit apparaît une fois dans la liste des dépenses avec une catégorie plausible. Resynchroniser et vérifier qu'aucun doublon n'apparaît.

**Acceptance Scenarios**:

1. **Given** un compte relié avec 20 débits sur la période, **When** l'utilisateur synchronise, **Then** 20 dépenses sont créées, marquées « importée », avec le libellé nettoyé, le montant, la date et une catégorie devinée (ou « Autres » à défaut).
2. **Given** une synchronisation déjà faite, **When** l'utilisateur synchronise à nouveau sans nouvelle opération, **Then** aucune dépense n'est ajoutée et l'app indique « Déjà à jour ».
3. **Given** une dépense saisie à la main (même montant, date à ±3 jours, nom proche), **When** l'opération bancaire correspondante est importée, **Then** l'app ne crée pas de doublon : elle rattache l'opération à la dépense existante.
4. **Given** une dépense importée puis supprimée par l'utilisateur, **When** il resynchronise, **Then** elle n'est pas réimportée.
5. **Given** des opérations de crédit (salaire, remboursement), **When** l'utilisateur synchronise, **Then** elles ne sont pas créées comme dépenses.
6. **Given** une opération encore « en attente » à la banque, **When** elle est importée puis devient définitive avec un libellé ou un montant différent, **Then** la dépense est mise à jour au lieu d'être dupliquée.

---

### User Story 3 - Rattacher les opérations aux récurrences (Priority: P2)

Quand une opération importée correspond à une récurrence existante (loyer, abonnement), elle remplace l'échéance que l'app avait générée pour ce mois, au lieu de s'y ajouter.

**Why this priority**: Sans ce rattachement, chaque charge fixe serait comptée deux fois : l'échéance générée par l'app et l'opération réelle. Les totaux et prévisions deviendraient faux.

**Independent Test**: Créer une récurrence « Loyer 800 € le 5 », relier un compte dont un débit de 800 € a lieu le 5, synchroniser, et vérifier qu'il n'y a qu'une seule dépense « Loyer » ce mois-ci, rattachée à la récurrence.

**Acceptance Scenarios**:

1. **Given** une récurrence mensuelle et son échéance déjà générée pour ce mois, **When** l'opération bancaire correspondante (montant à ±3 %, date à ±5 jours, nom proche) est importée, **Then** l'échéance générée est remplacée par l'opération réelle, qui reste rattachée à la récurrence.
2. **Given** une opération importée qui revient chaque mois sans récurrence associée, **When** la détection d'abonnements tourne, **Then** l'opération est proposée comme récurrence, comme pour les dépenses saisies à la main.

---

### User Story 4 - Recaler le solde sur la banque (Priority: P2)

Après une synchronisation, l'utilisateur peut recaler le « solde sur le compte » de l'app sur le solde réel communiqué par la banque.

**Why this priority**: Le solde estimé dérive avec le temps (dépenses oubliées, frais bancaires). Le recaler rend l'estimation de fin de mois fiable.

**Independent Test**: Synchroniser un compte dont le solde bancaire diffère du solde affiché, recaler, et vérifier que le solde de l'accueil est égal au solde bancaire.

**Acceptance Scenarios**:

1. **Given** un solde bancaire de 1 180,50 € et un solde affiché de 1 237 €, **When** l'utilisateur choisit « Utiliser le solde de la banque », **Then** le solde affiché devient 1 180,50 € et l'estimation de fin de mois est recalculée.
2. **Given** un écart de plus de 1 € entre les deux soldes, **When** une synchronisation se termine, **Then** l'app propose le recalage sans l'imposer.

---

### Edge Cases

- **Autorisation expirée** (en général après 90 à 180 jours) : la synchronisation échoue proprement. L'app affiche « Accès à ta banque expiré » avec un bouton pour renouveler l'autorisation. Les dépenses existantes restent intactes.
- **Pas de réseau ou banque indisponible** : un message clair s'affiche, rien n'est perdu et une nouvelle tentative est possible plus tard.
- **Plusieurs comptes chez la même banque** : l'utilisateur choisit le ou les comptes à suivre au moment de la liaison.
- **Opération en devise étrangère** : la dépense est importée avec le montant débité en euros.
- **Libellés bancaires bruts** (« CB CARREFOUR 03/10 PARIS 12 ») : les préfixes et suffixes techniques (CB, PRLV, date, ville) sont retirés pour obtenir un nom lisible.
- **Première synchronisation** : seules les opérations des 90 derniers jours sont importées, pour ne pas inonder l'historique.
- **Opération annulée par la banque** : si elle disparaît des opérations récentes alors qu'elle avait été importée « en attente », la dépense correspondante est retirée.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: L'utilisateur MUST pouvoir relier un ou plusieurs comptes de sa banque en passant par l'écran d'autorisation de la banque.
- **FR-002**: Le système MUST afficher, pour chaque compte relié, la banque, le libellé du compte, la date de la dernière synchronisation et la date d'expiration de l'autorisation.
- **FR-003**: L'utilisateur MUST pouvoir délier un compte. Les dépenses déjà importées sont conservées.
- **FR-004**: Le système MUST importer les opérations de débit d'un compte relié comme dépenses. Chaque dépense a un nom lisible, son montant en euros, sa date d'opération et une catégorie devinée par la même règle que la saisie manuelle.
- **FR-005**: Le système MUST garantir qu'une même opération bancaire ne produit jamais plus d'une dépense, quel que soit le nombre de synchronisations.
- **FR-006**: Le système MUST rapprocher une opération importée d'une dépense saisie à la main correspondante (même montant, date à ±3 jours) au lieu de créer un doublon.
- **FR-007**: Le système MUST se souvenir des dépenses importées que l'utilisateur a supprimées et ne pas les réimporter.
- **FR-008**: Le système MUST rattacher une opération importée à la récurrence correspondante (montant à ±3 %, date à ±5 jours) et remplacer l'échéance générée pour cette période.
- **FR-009**: Le système MUST ignorer les opérations de crédit lors de la création de dépenses.
- **FR-010**: Le système MUST lancer une synchronisation à l'ouverture de l'app si la dernière date de plus d'une heure, et MUST offrir un bouton « Synchroniser maintenant ».
- **FR-011**: Le système MUST afficher le résultat de chaque synchronisation : nombre de dépenses ajoutées, mises à jour ou rapprochées, ou « Déjà à jour ».
- **FR-012**: Le système MUST proposer, sans l'imposer, de recaler le solde du compte de l'app sur le solde bancaire quand l'écart dépasse 1 €.
- **FR-013**: Le système MUST signaler une autorisation expirée ou révoquée et permettre de la renouveler sans perdre les données.
- **FR-014**: Les dépenses importées MUST rester modifiables comme les autres (nom, catégorie, libellés). Une modification de l'utilisateur n'est pas écrasée par une synchronisation ultérieure, sauf pour une opération encore en attente.
- **FR-015**: Le système MUST distinguer visuellement une dépense importée d'une dépense saisie à la main.
- **FR-016**: Les dépenses importées MUST ne pas générer d'arrondi automatique, car l'arrondi n'a pas réellement été prélevé par la banque.
- **FR-017**: Les identifiants de l'application Enable Banking (identifiant d'application et clé) MUST pouvoir être fournis sans être publiés dans le dépôt de code.

### Key Entities

- **Compte relié** : un compte bancaire autorisé. Il comporte la banque, le libellé et l'identifiant du compte, la date d'expiration de l'autorisation, la date de dernière synchronisation et le dernier solde bancaire connu.
- **Opération bancaire** : un mouvement communiqué par la banque. Il comporte un identifiant stable, une date, un montant, un sens (débit ou crédit), un libellé brut et un statut (en attente ou définitive).
- **Lien d'import** : la correspondance entre une opération bancaire et une dépense de l'app (créée, rapprochée ou rattachée à une récurrence). C'est ce qui garantit l'absence de doublon.
- **Opération écartée** : une opération que l'utilisateur a supprimée après import et qui ne doit pas revenir.
- **Dépense** (existante) : elle reçoit une origine (« saisie » ou « importée ») et, le cas échéant, le lien vers son opération bancaire.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: La liaison d'un compte, du choix de la banque au retour dans l'app avec le compte affiché, prend moins de 2 minutes.
- **SC-002**: Après 10 synchronisations successives sur la même période, le nombre de dépenses importées est identique à celui de la première : 0 doublon.
- **SC-003**: Au moins 80 % des opérations importées reçoivent automatiquement une catégorie autre que « Autres » sur un mois type (courses, transports, abonnements).
- **SC-004**: Une synchronisation de 3 mois d'opérations, environ 150 opérations, se termine en moins de 10 secondes avec une connexion normale.
- **SC-005**: Après recalage, le solde affiché à l'accueil est égal au centime près au solde communiqué par la banque.
- **SC-006**: Une autorisation expirée ne provoque ni plantage ni perte de données : 100 % des dépenses existantes restent visibles.

## Assumptions

- Projet d'école à usage personnel. L'accès se fait en mode restreint gratuit d'Enable Banking, limité aux comptes que l'utilisateur a lui-même reliés dans le portail Enable Banking. La publication pour d'autres utilisateurs est hors périmètre.
- Les opérations peuvent transiter par Enable Banking et la banque. La règle « les données restent sur le téléphone » est levée pour cette fonctionnalité, et la constitution est amendée en conséquence.
- L'identifiant d'application et la clé privée sont fournis à la compilation ou dans un fichier local ignoré par git. Pour cet usage personnel, ils peuvent résider sur l'appareil, sans serveur intermédiaire.
- La banque de l'utilisateur fait partie des banques couvertes par Enable Banking. C'est à vérifier dans leur liste avant l'implémentation.
- Seul l'euro est géré, comme dans le reste de l'app.
- Le retour depuis l'écran d'autorisation de la banque se fait par un lien profond vers l'app sur Android, et par une adresse de retour locale sur Windows et le web.
- La première synchronisation couvre 90 jours d'historique.
- Les crédits (salaire, remboursements) ne sont pas importés. Le salaire reste géré par le jour de paie existant.
