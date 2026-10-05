import 'package:get_it/get_it.dart';

import 'bank_import_dependencies.dart';
import 'bank_link_dependencies.dart';

void registerBankSyncDependencies(GetIt getIt) {
  registerBankLinkDependencies(getIt);
  registerBankImportDependencies(getIt);
}
