import 'package:depenses/layers/functional/Appearance/domain/entities/appearance_settings.dart';
import 'package:depenses/layers/functional/Appearance/presentation/theme/appearance_tokens.dart';
import 'package:depenses/layers/functional/Onboarding/presentation/views/onboarding_view.dart';
import 'package:depenses/layers/technical/Theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';

import 'app_router.dart';
import 'l10n/app_locale.dart';
import 'session/app_session_cubit.dart';
import 'session/app_session_state.dart';
import 'shell/shell_view.dart';

class DepensesMaterialApp extends StatelessWidget {
  const DepensesMaterialApp({super.key, required this.appearance, required this.platformBrightness});

  final AppearanceSettings appearance;
  final Brightness platformBrightness;

  @override
  Widget build(BuildContext context) {
    final tokens = appearance.tokensWith(platformBrightness);
    final isDark = tokens.isDark;
    final localization = FlutterLocalization.instance;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark).copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: tokens.isGraphite ? tokens.bg : tokens.card,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: MaterialApp(
        onGenerateTitle: (context) => AppLocale.title.getString(context),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(tokens),
        supportedLocales: localization.supportedLocales,
        localizationsDelegates: localization.localizationsDelegates,
        onGenerateRoute: AppRouter(tokens).onGenerateRoute,
        home: BlocBuilder<AppSessionCubit, AppSessionState>(
          builder: (context, session) => session.isOnboarded
              ? const ShellView()
              : OnboardingView(onCompleted: context.read<AppSessionCubit>().completeOnboarding),
        ),
      ),
    );
  }
}
