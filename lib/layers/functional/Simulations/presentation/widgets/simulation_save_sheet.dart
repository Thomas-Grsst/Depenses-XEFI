import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_text_field.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/simulations_locale.dart';
import 'simulations_tag.dart';

const _tagSeparator = ' · ';

class SimulationSaveSheet extends StatefulWidget {
  const SimulationSaveSheet({
    super.key,
    required this.initialTitle,
    required this.initialDescription,
    required this.tags,
  });

  final String initialTitle;
  final String initialDescription;
  final List<String> tags;

  @override
  State<SimulationSaveSheet> createState() => _SimulationSaveSheetState();
}

class _SimulationSaveSheetState extends State<SimulationSaveSheet> {
  late final _title = TextEditingController(text: widget.initialTitle);
  late final _description = TextEditingController(text: widget.initialDescription);

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final gap = SizedBox(height: graphite ? 22 : 14);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(context.tr(SimulationsLocale.titleLabel), controller: _title, autofocus: true),
        gap,
        AppTextField(
          context.tr(SimulationsLocale.descriptionLabel),
          controller: _description,
          lines: 3,
          hint: context.tr(SimulationsLocale.descriptionHint),
        ),
        gap,
        if (graphite)
          Text(widget.tags.join(_tagSeparator).toUpperCase(), style: tokens.mono(11, tokens.muted))
        else
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final tag in widget.tags)
                SimulationsTag(tag, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
            ],
          ),
        gap,
        AppButton.primary(
          context.tr(SimulationsLocale.saveAndCompare),
          onTap: () => Navigator.pop(context, (_title.text, _description.text)),
        ),
        const SizedBox(height: 10),
        Text(
          context.tr(SimulationsLocale.budgetUnchanged),
          textAlign: TextAlign.center,
          style: tokens.ts(12, tokens.wSemi, graphite ? tokens.faint : tokens.muted),
        ),
      ],
    );
  }
}
