import 'package:depenses/layers/functional/Recurrences/domain/entities/recurring_suggestion.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_small_button.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/show_app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/recurrences_cubit.dart';
import '../l10n/recurrences_locale.dart';

class RecurrenceSuggestionActions extends StatelessWidget {
  const RecurrenceSuggestionActions({super.key, required this.suggestion});

  final RecurringSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RecurrencesCubit>();
    return Row(
      children: [
        AppSmallButton.primary(
          context.tr(RecurrencesLocale.create),
          onTap: () {
            cubit.acceptSuggestion(suggestion);
            showAppToast(context, context.tr(RecurrencesLocale.created));
          },
        ),
        const SizedBox(width: AppSpacing.sm),
        AppSmallButton.secondary(context.tr(RecurrencesLocale.ignore), onTap: () => cubit.ignoreSuggestion(suggestion)),
      ],
    );
  }
}
