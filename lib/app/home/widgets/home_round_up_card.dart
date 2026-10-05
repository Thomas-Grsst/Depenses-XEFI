import 'package:depenses/layers/functional/Savings/presentation/cubit/savings_summary_cubit.dart';
import 'package:depenses/layers/functional/Savings/presentation/widgets/savings_round_up_card.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeRoundUpCard extends StatelessWidget {
  const HomeRoundUpCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SavingsSummaryCubit>().state;
    final month = state.month;
    final isVisible = state.isRoundUpEnabled || state.summary.total > 0;
    if (!isVisible || month == null) return const SizedBox.shrink();
    return SavingsRoundUpCard(summary: state.summary, month: month, lastRounded: state.lastRounded);
  }
}
