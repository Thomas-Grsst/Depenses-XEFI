import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entities/sync_report.dart';
import '../cubit/bank_sync_failure.dart';
import 'bank_import_locale.dart';
import 'bank_sync_locale.dart';

extension BankSyncMessages on BuildContext {
  String syncReportMessage(SyncReport report) {
    if (report.isUpToDate) return tr(BankImportLocale.upToDate);
    final matched = report.matched + report.attachedToRecurrence;
    return [
      if (report.created > 0) _counted(report.created, BankImportLocale.createdOne, BankImportLocale.createdOther),
      if (report.updated > 0) _counted(report.updated, BankImportLocale.updatedOne, BankImportLocale.updatedOther),
      if (matched > 0) _counted(matched, BankImportLocale.matchedOne, BankImportLocale.matchedOther),
      if (report.removed > 0) _counted(report.removed, BankImportLocale.removedOne, BankImportLocale.removedOther),
    ].join(tr(BankSyncLocale.reportSeparator));
  }

  String linkedAccountsMessage(int count) => _counted(count, BankSyncLocale.linkedOne, BankSyncLocale.linkedOther);

  String bankSyncFailureMessage(BankSyncFailure failure) => tr(switch (failure) {
    BankSyncFailure.expired => BankSyncLocale.failureExpired,
    BankSyncFailure.notConfigured => BankSyncLocale.failureNotConfigured,
    BankSyncFailure.browserUnavailable => BankSyncLocale.failureBrowser,
    BankSyncFailure.unavailable || BankSyncFailure.none => BankSyncLocale.failureUnavailable,
  });

  String bankDate(DateTime date) => '${dates.dayAndMonth(date)} ${date.year}';

  String _counted(int count, String one, String other) => trWith(count == 1 ? one : other, [count]);
}
