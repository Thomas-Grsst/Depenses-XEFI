import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/recurrences_cubit.dart';
import 'recurrences_calendar_dots.dart';

class RecurrencesCalendarDayCell extends StatelessWidget {
  const RecurrencesCalendarDayCell({
    super.key,
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.isPast,
    required this.dotCategories,
  });

  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final bool isPast;
  final List<Category> dotCategories;

  @override
  Widget build(BuildContext context) => AppPressable(
    onTap: () => context.read<RecurrencesCubit>().selectDay(date),
    child: context.tokens.isGraphite ? _GraphiteDayFace(cell: this) : _MentheDayFace(cell: this),
  );
}

class _GraphiteDayFace extends StatelessWidget {
  const _GraphiteDayFace({required this.cell});

  final RecurrencesCalendarDayCell cell;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final dayColor = cell.isSelected ? tokens.fabInk : (cell.isPast ? tokens.muted : tokens.ink);
    return SizedBox(
      height: 46,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: cell.isSelected ? tokens.fab : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: cell.isToday && !cell.isSelected ? tokens.fab : Colors.transparent),
            ),
            child: Text('${cell.date.day}', style: tokens.ts(14, FontWeight.w400, dayColor)),
          ),
          const SizedBox(height: 4),
          RecurrencesCalendarDots.single(hasEntries: cell.dotCategories.isNotEmpty, isPast: cell.isPast),
        ],
      ),
    );
  }
}

class _MentheDayFace extends StatelessWidget {
  const _MentheDayFace({required this.cell});

  final RecurrencesCalendarDayCell cell;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final weight = cell.isSelected || cell.isToday ? FontWeight.w800 : FontWeight.w600;
    final dayColor = cell.isSelected ? tokens.bg : (cell.isPast ? tokens.faint : tokens.ink);
    return Container(
      height: 48,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: cell.isSelected ? tokens.ink : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cell.isToday && !cell.isSelected ? tokens.mint : Colors.transparent, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${cell.date.day}', style: tokens.ts(14, weight, dayColor)),
          const SizedBox(height: 3),
          RecurrencesCalendarDots.colored(categories: cell.dotCategories),
        ],
      ),
    );
  }
}
