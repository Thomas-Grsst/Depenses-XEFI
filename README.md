# Dépenses

App Flutter de suivi des dépenses personnelles, pour Android, Windows et le web. Les données sont stockées sur l'appareil. Seule la synchronisation bancaire, si tu l'actives, passe par Enable Banking.

- Solde du compte tenu à jour (dépenses, salaire au jour de paie) et estimation de fin de mois
- Dépenses occasionnelles et récurrentes (calendrier des échéances)
- Synchronisation bancaire (Enable Banking) : les opérations deviennent des dépenses, sans doublon, rattachées aux récurrences, et le solde peut être recalé sur celui de la banque
- Budget par catégorie et enveloppes par libellé, alertes de rythme
- Catégories personnalisées
- Prévision du mois, comparaison avec le mois précédent
- Simulations (« et si mon loyer passait à 900 € ? ») sans toucher au budget
- Deux styles : Menthe (palettes Menthe, Océan, Prune, Terracotta) et Graphite, en clair ou sombre

## Lancer

```bash
flutter pub get
flutter run -d windows
```

## Synchronisation bancaire

1. Crée une application sur [enablebanking.com](https://enablebanking.com/sign-in/) (« API applications » → « Add a new application »). Déclare l'adresse de retour `http://localhost:8765/bank-callback` et garde le fichier `.pem` téléchargé. Le nom de ce fichier est l'identifiant de l'application.
2. Copie `config/enable_banking.example.json` vers `config/enable_banking.json`. Ce fichier est ignoré par git. Renseigne :
   - `ENABLE_BANKING_APP_ID` : le nom du fichier `.pem`, sans l'extension.
   - `ENABLE_BANKING_PRIVATE_KEY` : le contenu du `.pem` sur une seule ligne, avec les sauts de ligne écrits `\n`. Enregistre le fichier en UTF-8 sans BOM.
3. Lance l'app avec la configuration :

```bash
flutter run -d windows --dart-define-from-file=config/enable_banking.json
```

Ensuite, va dans Profil → Ma banque → Relier ma banque.
- **En Sandbox :** la banque « Mock ASPSP » ne demande aucun identifiant. Ses comptes et transactions se gèrent dans l'onglet Mock ASPSP du portail.
- **Pour ta vraie banque :** utilise une application en Production et relie ton compte dans le portail (« Link accounts »).

## Tests

```bash
flutter analyze
flutter test
```

## Compiler l'APK

```bash
flutter build apk --release --dart-define-from-file=config/enable_banking.json
```

L'APK est généré dans `build/app/outputs/flutter-apk/app-release.apk`. La clé Enable Banking y est intégrée : ne le distribue pas.
