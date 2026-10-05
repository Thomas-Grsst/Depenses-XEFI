import 'package:depenses/layers/functional/Recurrences/presentation/widgets/occurrence_row.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_list_section.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shell/shell_tab.dart';
import '../../shell/shell_tab_cubit.dart';
import '../cubit/home_lists_cubit.dart';
import '../l10n/home_locale.dart';

class HomeUpcomingSection extends StatelessWidget {
  const HomeUpcomingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeListsCubit>().state;
    return AppListSection(
      title: context.tr(context.tokens.isGraphite ? HomeLocale.upcomingTitleShort : HomeLocale.upcomingTitle),
      action: context.tr(HomeLocale.seeAll),
      onAction: () => context.read<ShellTabCubit>().select(ShellTab.recurrences),
      empty: context.tr(HomeLocale.upcomingEmpty),
      children: [
        for (final item in state.upcoming)
          OccurrenceRow.home(occurrence: item.occurrence, look: item.look, category: item.category, today: state.today),
      ],
    );
  }
}
