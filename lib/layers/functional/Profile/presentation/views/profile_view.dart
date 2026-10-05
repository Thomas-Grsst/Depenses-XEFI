import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/show_app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../l10n/profile_locale.dart';
import '../widgets/profile_content.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.goalsSection});

  final Widget goalsSection;

  Future<void> _copyCsv(BuildContext context, ProfileState state) async {
    await Clipboard.setData(ClipboardData(text: state.exportedCsv));
    if (!context.mounted) return;
    showAppToast(context, context.trWith(ProfileLocale.exportDone, [state.overview.expenseCount]));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ProfileCubit>(),
      child: BlocListener<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) => previous.exportCount != current.exportCount,
        listener: _copyCsv,
        child: ProfileContent(goalsSection: goalsSection),
      ),
    );
  }
}
