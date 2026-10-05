# Phase 0 — Recherche : synchronisation bancaire Enable Banking

## R1. Fournisseur et mode d'accès

- **Décision** : Enable Banking en mode restreint gratuit (« linked accounts »). L'application est créée dans le Control Panel Enable Banking, et les comptes de l'utilisateur y sont reliés une fois, ce qui les rend accessibles gratuitement en production.
- **Pourquoi** : c'est la seule offre gratuite et ouverte aux nouveaux inscrits en 2026 qui couvre les banques européennes via les API DSP2 officielles. Elle suffit pour un projet d'école à usage personnel.
- **Alternatives écartées** :
  - GoCardless Bank Account Data : n'accepte plus d'inscriptions depuis juillet 2025.
  - Bridge (à partir de 30 €/mois) et Powens (sur devis) : payants et orientés entreprise.
  - Import CSV/OFX manuel : pas d'automatisation, donc moins de valeur. Il reste un plan B si la banque n'est pas couverte.

## R2. Authentification auprès de l'API

- **Décision** : chaque appel porte `Authorization: Bearer <JWT>`. Le JWT est signé en RS256 avec la clé privée de l'application :
  - en-tête `kid` = identifiant d'application ;
  - claims `iss = "enablebanking.com"`, `aud = "api.enablebanking.com"`, `iat` = maintenant, `exp = iat + 3600` (une heure au plus).
  - Le JWT est mis en cache et régénéré 5 minutes avant expiration.
- **Bibliothèque** : `dart_jsonwebtoken` pour la signature RS256 et `http` pour le transport. Les deux sont maintenus, sans génération de code, compatibles Android, Windows et web.
- **Alternatives écartées** :
  - Signature RSA à la main avec `pointycastle` : plus de code, plus de risques.
  - Serveur intermédiaire qui garderait la clé : hors périmètre pour un usage personnel (cf. hypothèses de la spec).

## R3. Secrets (identifiant d'application et clé privée)

- **Décision** : ils sont fournis à la compilation avec `--dart-define-from-file=config/enable_banking.json`. Ce fichier est ignoré par git, et le dépôt contient seulement un `config/enable_banking.example.json` vide.
  - `ENABLE_BANKING_APP_ID` contient l'identifiant d'application.
  - `ENABLE_BANKING_PRIVATE_KEY` contient la clé PEM, avec les sauts de ligne encodés en `\n`.
  - Sans configuration, la fonctionnalité est masquée (« Synchronisation bancaire non configurée »).
- **Pourquoi** : ça respecte FR-017 et la constitution (« credentials never committed »), sans écran de saisie de clé.
- **Données de session** (`session_id`, `uid` des comptes) : elles sont stockées avec `flutter_secure_storage`, parce qu'elles donnent accès aux opérations. Les métadonnées non sensibles (nom de la banque, dates) vont dans le ledger JSON.

## R4. Retour d'autorisation (redirect_url)

- **Décision** : une adresse de retour par plateforme, toutes déclarées dans la liste blanche du Control Panel.
  - **Windows** : boucle locale `http://localhost:8765/bank-callback`. Un `HttpServer` de `dart:io` éphémère attend le `code` puis affiche « Tu peux revenir dans l'app ». Le navigateur est ouvert avec `url_launcher`.
  - **Android** : lien profond `depenses://bank-callback`, déclaré dans l'`intent-filter` et reçu avec `app_links`.
  - **Web** : `http://localhost:8080/#/bank-callback`, lu comme une route de l'app.
- **Plan B** : si Enable Banking refuse le schéma personnalisé, un champ « Colle l'adresse de retour » extrait `code` et `state` de l'URL collée. Ça ne coûte rien et ça marche partout.
- **Sécurité** : le `state` est un UUID généré à chaque tentative et comparé au retour, sinon la tentative est rejetée (CSRF).
- **À vérifier à l'implémentation** : si le Control Panel accepte `depenses://` et `http://localhost`.

## R5. Récupération des opérations

- **Décision** : `GET /accounts/{uid}/transactions?date_from=…`, en suivant `continuation_key` jusqu'à épuisement. `date_from` vaut :
  - aujourd'hui − 90 jours à la première synchronisation ;
  - sinon, la dernière synchronisation − 10 jours, pour rattraper les opérations en attente devenues définitives.
- **Champs utilisés** :
  - `entry_reference` (sinon `transaction_id`) : identifiant stable ;
  - `transaction_amount.amount` et `currency` ;
  - `credit_debit_indicator` (`DBIT` ou `CRDT`) ;
  - `status` (`BOOK` = définitive, `PDNG` = en attente) ;
  - `booking_date`, sinon `value_date`, sinon `transaction_date` ;
  - `remittance_information[]` et `creditor.name` pour le libellé.
  - Les noms exacts sont à confirmer contre la référence API au premier appel réel. Ils sont isolés dans le DTO de la couche data.
- **Identifiant de rapprochement** : `entry_reference` quand il est présent. Sinon, une empreinte `date|montant|libellé normalisé` (cas d'une opération en attente sans référence).

## R6. Solde bancaire

- **Décision** : `GET /accounts/{uid}/balances`. On retient dans l'ordre de préférence `ITAV` (interim available), puis `CLAV`, `ITBD` et `CLBD`. Le montant en euros sert au recalage (US4).

## R7. Nettoyage des libellés

- **Décision** : des règles déterministes dans le domaine, testées unitairement.
  - Retrait des préfixes `CB`, `CARTE`, `PRLV SEPA`, `VIR SEPA`, `PAIEMENT PAR CARTE`, `ACHAT`.
  - Retrait des dates (`03/10`, `031025`), des numéros de carte masqués (`X1234`) et des codes postaux ou villes en fin de libellé.
  - Mise en casse de titre (`CARREFOUR MARKET` devient `Carrefour Market`).
  - La catégorie est ensuite devinée par `GuessCategoryUseCase` (existant).

## R8. Rapprochement et doublons

- **Décision** : un `BankLink` est créé par opération importée (identifiant d'opération → identifiant de dépense) et persisté. L'ordre d'évaluation pour une opération de débit :
  1. Déjà liée : on met à jour la dépense seulement si l'opération était en attente et a changé (FR-014).
  2. Écartée par l'utilisateur : on l'ignore (FR-007).
  3. Échéance de récurrence générée, même `recurrenceId` candidat (montant ±3 %, date ±5 jours, nom proche), non encore liée : on la remplace par l'opération réelle en gardant `recurrenceId` (FR-008).
  4. Dépense manuelle non liée de même montant, à ±3 jours : on la rapproche, c'est-à-dire qu'on la lie sans la modifier (FR-006).
  5. Sinon : on crée une dépense importée sans arrondi (FR-016).
  - « Nom proche » signifie que les noms normalisés (`normalizeForMatching`) partagent le premier mot, ou que l'un contient l'autre.

## R9. Déclenchement

- **Décision** : `AppSessionCubit.resume()` lance aussi la synchronisation si un compte est relié et que la dernière date de plus d'une heure (FR-010). Un bouton manuel est disponible dans l'écran « Ma banque ». Les erreurs ne bloquent jamais l'ouverture de l'app.
