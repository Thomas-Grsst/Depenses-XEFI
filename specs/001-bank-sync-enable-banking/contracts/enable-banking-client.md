# Contrat — client Enable Banking (couche technique `OpenBanking`)

Selon la convention « API via SDK », aucun appel HTTP direct hors de ce client. Il n'existe pas de SDK Dart officiel, d'où un client maison avec une méthode typée par opération.

```text
EnableBankingClient(EnableBankingConfig config, http.Client transport, Clock clock)

  Future<List<AspspDto>>            listBanks({required String country})
      GET /aspsps?country={country}

  Future<AuthorizationStartDto>     startAuthorization({required String bankName, required String country,
                                                        required DateTime validUntil, required String state,
                                                        required String redirectUrl})
      POST /auth  { access: { valid_until }, aspsp: { name, country }, state, redirect_url, psu_type: "personal" }
      → { url }

  Future<SessionDto>                createSession({required String code})
      POST /sessions { code } → { session_id, accounts: [ { uid, account_id, name, … } ], access: { valid_until } }

  Future<List<BalanceDto>>          balances(String accountUid)
      GET /accounts/{uid}/balances → { balances: [ { balance_type, balance_amount: { amount, currency } } ] }

  Future<TransactionPageDto>        transactions(String accountUid, {required DateTime from, String? continuationKey})
      GET /accounts/{uid}/transactions?date_from=YYYY-MM-DD[&continuation_key=…]
      → { transactions: [ … ], continuation_key? }

  Future<void>                      deleteSession(String sessionId)
      DELETE /sessions/{session_id}
```

## Correspondance des erreurs

Erreurs nommées, jamais une `Exception` générique :

| Réponse | Exception |
|---|---|
| 401, 403, session expirée ou révoquée | `BankAccessExpiredException` |
| 429 | `BankRateLimitedException` |
| 5xx, timeout (20 s), pas de réseau | `BankUnavailableException` |
| JSON inattendu | `BankResponseFormatException` |
| configuration absente | `BankSyncNotConfiguredException` |

## Contrats de domaine (couche fonctionnelle `BankSync`)

```text
BankDirectoryGateway      List<Bank> banks(String country)
BankAuthorizationGateway  Future<Uri> start(Bank bank, String state)
                          Future<List<LinkedBankAccount>> complete(String code)
                          Future<void> revoke(LinkedBankAccount account)
BankDataGateway           Future<List<BankTransaction>> transactions(LinkedBankAccount account, DateTime from)
                          Future<double?> balance(LinkedBankAccount account)
LinkedAccountGateway      List<LinkedBankAccount> all() / save / remove
BankLinkGateway           List<BankLink> all() / saveAll ; Set<String> dismissed() / dismiss(String)
```
