import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'app/app_dependencies.dart';
import 'app/app_localization.dart';
import 'app/depenses_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await registerAppDependencies(GetIt.I);
  await prepareAppLocalization();
  runApp(const DepensesApp());
}
