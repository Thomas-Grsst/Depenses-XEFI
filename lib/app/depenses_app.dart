import 'package:depenses/layers/functional/Appearance/domain/entities/appearance_settings.dart';
import 'package:depenses/layers/functional/Appearance/presentation/cubit/appearance_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'depenses_material_app.dart';
import 'session/app_session_cubit.dart';

class DepensesApp extends StatefulWidget {
  const DepensesApp({super.key});

  @override
  State<DepensesApp> createState() => _DepensesAppState();
}

class _DepensesAppState extends State<DepensesApp> with WidgetsBindingObserver {
  late final AppSessionCubit _session = GetIt.I<AppSessionCubit>();
  late final AppearanceCubit _appearance = GetIt.I<AppearanceCubit>();
  Brightness _platformBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _session.close();
    _appearance.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _session.resume();
  }

  @override
  void didChangePlatformBrightness() =>
      setState(() => _platformBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness);

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: _session),
      BlocProvider.value(value: _appearance),
    ],
    child: BlocBuilder<AppearanceCubit, AppearanceSettings>(
      builder: (context, appearance) =>
          DepensesMaterialApp(appearance: appearance, platformBrightness: _platformBrightness),
    ),
  );
}
