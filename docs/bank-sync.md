# Synchronisation bancaire (Enable Banking)

L'app peut lire les opérations d'un compte bancaire via [Enable Banking](https://enablebanking.com), un agrégateur agréé DSP2, et les transformer en dépenses. La spec complète, le plan et les tâches sont dans [specs/001-bank-sync-enable-banking/](../specs/001-bank-sync-enable-banking/).

## Comment ça marche

```text
Ta banque  ⇄  Enable Banking  ⇄  l'app (couches OpenBanking + BankSync)
```

1. **Liaison**, une fois tous les 90 à 180 jours selon la banque :
   - L'app ouvre la page d'autorisation de la banque. Tu t'y authentifies et tu donnes un accès en lecture seule.
   - La banque renvoie vers l'app un `code`, que l'app échange contre une session et la liste des comptes.
   - À l'expiration de l'accès, l'app affiche « Renouveler l'accès ».
2. **Synchronisation** :
   - Elle se lance à l'ouverture de l'app si la dernière date de plus d'une heure, ou avec le bouton « Synchroniser maintenant » de l'écran **Ma banque**.
   - L'app récupère les opérations : sur 90 jours la première fois, puis depuis la dernière synchronisation moins 10 jours.
   - Elle lit aussi le solde, en préférant ITAV, puis CLAV, ITBD et CLBD.
3. **Rapprochement** de chaque débit (les crédits sont ignorés), dans cet ordre :
   1. Opération déjà liée : la dépense est mise à jour seulement si l'opération était « en attente ».
   2. Opération écartée (dépense importée puis supprimée) : elle est ignorée.
   3. **Récurrence** correspondante (nom proche, montant à ±3 %, date à ±5 jours) : l'échéance générée par l'app est remplacée par l'opération réelle.
   4. **Dépense saisie à la main** de même montant, à ±3 jours : elle est rattachée, sans être modifiée.
   5. Sinon, une **nouvelle dépense « Importée »** est créée, avec un libellé nettoyé (`CB CARREFOUR 03/10 PARIS` devient `Carrefour`), une catégorie devinée et sans arrondi.
4. **Solde** : si le solde bancaire diffère de plus de 1 € de celui de l'app, un bandeau « Utiliser ce solde » apparaît sur l'accueil et sur Ma banque. Le recalage n'est jamais automatique.

L'app ne tourne pas en arrière-plan et la banque ne la prévient pas des nouveaux achats. Un achat apparaît à la synchronisation suivante, avec le délai de la banque : opération « en attente » dans la journée, « définitive » sous 1 à 3 jours.

## Configuration

### 1. Créer l'application Enable Banking

1. Se connecter sur https://enablebanking.com/sign-in/. Le compte est créé à la première connexion par lien e-mail.
2. Aller dans **API applications** → **Add a new application** :
   - **Environment** : *Sandbox* pour tester, *Production* pour une vraie banque.
   - **Private key** : option par défaut. Le navigateur génère la clé et télécharge un fichier `<application-id>.pem`.
   - **Redirect URLs** : `http://localhost:8765/bank-callback` pour Windows. Ajouter `depenses://bank-callback` pour Android et `http://localhost:8080/#/bank-callback` pour le web si besoin.
3. Le **nom du fichier `.pem`, sans l'extension, est l'identifiant de l'application**.

### 2. Créer `config/enable_banking.json`

Ce fichier n'est pas versionné : il est dans `.gitignore`. Sa forme est donnée par `config/enable_banking.example.json` :

```json
{"ENABLE_BANKING_APP_ID": "<application-id>", "ENABLE_BANKING_PRIVATE_KEY": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----"}
```

- La clé doit tenir **sur une seule ligne**, avec les sauts de ligne écrits `\n`.
- Le fichier doit être enregistré en **UTF-8 sans BOM**. Avec un BOM ou des retours à la ligne réels, le compilateur Dart s'arrête (« The Dart compiler exited unexpectedly »).

Commande PowerShell qui génère le fichier correctement à partir du `.pem` (remplace le chemin) :

```powershell
$pem = Get-Item "$env:USERPROFILE\Downloads\<application-id>.pem"; $key = ((Get-Content $pem.FullName -Raw).Trim() -replace "`r", '') -replace "`n", '\n'; $json = '{"ENABLE_BANKING_APP_ID": "' + $pem.BaseName + '", "ENABLE_BANKING_PRIVATE_KEY": "' + ($key -replace '\\', '\\') + '"}'; [IO.File]::WriteAllText("$PWD\config\enable_banking.json", $json, (New-Object Text.UTF8Encoding $false))
```

### 3. Lancer avec la configuration

```bash
flutter run -d windows --dart-define-from-file=config/enable_banking.json
```

L'identifiant et la clé sont intégrés à la compilation : relance l'app après chaque changement du fichier.

## Tester en Sandbox (Mock ASPSP)

- **Banque à choisir :** dans l'app, Profil → **Ma banque** → **Relier ma banque**, puis **Mock ASPSP**. Elle ne demande aucun identifiant.
  - Ne pas utiliser `customera` / `12345678` : ces identifiants servent aux paiements de test, pas à la connexion à une banque.
  - Seule autre banque française de test : BBVA (`user1` / `1234` / OTP `012345`).
- **Données de test :** les comptes, les transactions et les soldes se créent dans le portail, sur https://enablebanking.com/cp/mock-aspsp. Une transaction n'est importée que si c'est un **débit** daté des **90 derniers jours**, posé sur un **compte relié** à l'app.
- **Après un ajout :** si tu ajoutes des transactions à un compte déjà relié, un simple « Synchroniser maintenant » suffit. Si tu crées un nouveau compte, il faut relier la banque à nouveau pour l'inclure.

## Production (vraie banque)

- **Application :** il en faut une en **Production**, avec les mêmes adresses de retour.
- **Mode restreint gratuit :** relie ton propre compte dans le portail (**Link accounts**). L'app n'a alors accès qu'aux comptes reliés de cette façon, c'est-à-dire à un usage personnel.
- **Authentification :** elle se fait chez la banque, avec ses identifiants et une validation forte (notification, SMS…). L'app ne voit jamais ces identifiants.
- **Fréquence :** la loi limite à environ 4 lectures par jour celles faites sans l'utilisateur. L'app ne synchronise qu'à l'ouverture, donc ça ne pose pas de problème.
- **Libellés :** chaque banque a son format. Le nettoyage (`BankLabelCleaner`) et la catégorie devinée peuvent demander des ajustements une fois face aux vrais relevés.
- **Diffusion :** la clé privée est intégrée à l'APK ou à l'exe, qu'il ne faut donc **jamais** distribuer. Ouvrir l'app à d'autres utilisateurs demanderait un contrat Enable Banking payant et un serveur qui garde la clé.

## Dépannage

| Symptôme | Cause / solution |
|---|---|
| « Synchronisation bancaire non configurée » | App lancée sans `--dart-define-from-file=config/enable_banking.json`, ou fichier vide |
| « The Dart compiler exited unexpectedly » | `config/enable_banking.json` avec un BOM ou une clé sur plusieurs lignes : le régénérer avec la commande ci-dessus |
| Build Windows : `atlstr.h` introuvable | Un plugin a besoin du composant ATL de Visual Studio. L'app utilise volontairement `shared_preferences` au lieu de `flutter_secure_storage` pour l'éviter |
| L'app ne revient pas seule après l'autorisation | Copier l'adresse de la page finale (`…/bank-callback?code=…&state=…`) et la coller dans le champ « Colle l'adresse de retour » de l'écran de choix de la banque. Vérifier que l'adresse de retour déclarée chez Enable Banking est exactement `http://localhost:8765/bank-callback` |
| « Déjà à jour » alors que des transactions existent | Elles ne sont pas sur un compte relié, ce sont des crédits, ou elles datent de plus de 90 jours |
| « Renouveler l'accès » | L'autorisation a expiré : refaire la liaison |
| Android : retour perdu si l'app a été fermée pendant l'autorisation | Limite connue : rouvrir l'écran de choix de la banque, ou coller l'adresse de retour |

## Où est le code

| Partie | Emplacement |
|---|---|
| Client HTTP, JWT, DTO, erreurs | `lib/layers/technical/OpenBanking/` |
| Retour d'autorisation (Windows, Android, web) | `lib/layers/technical/OpenBanking/callback/` |
| Entités, contrats, use cases | `lib/layers/functional/BankSync/domain/` |
| Accès à l'API et stockage | `lib/layers/functional/BankSync/data/` |
| Écrans Ma banque, choix de la banque, retour, bandeau de solde | `lib/layers/functional/BankSync/presentation/` |
| Synchronisation au retour dans l'app | `lib/app/session/app_session_cubit.dart` |
| Tests et fixtures | `test/layers/technical/OpenBanking/`, `test/layers/functional/BankSync/` |
