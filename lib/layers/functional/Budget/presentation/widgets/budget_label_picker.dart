import 'package:depenses/layers/technical/Theme/app_pill_chip.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:flutter/material.dart';

class BudgetLabelPicker extends StatelessWidget {
  const BudgetLabelPicker({super.key, required this.labels, required this.selection});

  final List<String> labels;
  final ValueNotifier<String> selection;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String>(
    valueListenable: selection,
    builder: (context, selected, _) => Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final label in labels)
          AppPillChip(label, selected: label == selected, onTap: () => selection.value = label),
      ],
    ),
  );
}
