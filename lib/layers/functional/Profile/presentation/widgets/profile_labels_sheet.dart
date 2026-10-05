import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_sheet.dart';
import 'package:depenses/layers/technical/Theme/app_small_button.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_text_field.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../l10n/profile_locale.dart';
import 'profile_label_row.dart';

class ProfileLabelsSheet extends StatefulWidget {
  const ProfileLabelsSheet({super.key});

  static Future<void> show(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return AppSheet.show<void>(
      context,
      title: context.tr(ProfileLocale.labels),
      closeLabel: context.tr(ProfileLocale.close),
      builder: (_) => BlocProvider.value(value: cubit, child: const ProfileLabelsSheet()),
    );
  }

  @override
  State<ProfileLabelsSheet> createState() => _ProfileLabelsSheetState();
}

class _ProfileLabelsSheetState extends State<ProfileLabelsSheet> {
  final _newLabel = TextEditingController();

  @override
  void dispose() {
    _newLabel.dispose();
    super.dispose();
  }

  Future<void> _add(ProfileCubit cubit) async {
    final added = await cubit.addLabel(_newLabel.text);
    if (added != null) _newLabel.clear();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final cubit = context.read<ProfileCubit>();
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.tr(ProfileLocale.labelsHelp),
            style: tokens.ts(13, tokens.wBody, tokens.muted).copyWith(height: 1.4),
          ),
          const SizedBox(height: 10),
          for (final usage in state.overview.labels)
            ProfileLabelRow(usage: usage, onDelete: () => cubit.removeLabel(usage.label)),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: AppTextField(
                  context.tr(ProfileLocale.newLabel),
                  controller: _newLabel,
                  hint: context.tr(ProfileLocale.newLabelHint),
                ),
              ),
              const SizedBox(width: 10),
              AppSmallButton.primary(context.tr(ProfileLocale.add), onTap: () => _add(cubit)),
            ],
          ),
        ],
      ),
    );
  }
}
