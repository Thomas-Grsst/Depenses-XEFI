import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_small_button.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_text_field.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/bank_picker_cubit.dart';
import '../l10n/bank_sync_locale.dart';

class BankCallbackPasteField extends StatefulWidget {
  const BankCallbackPasteField({super.key, required this.isInvalid});

  final bool isInvalid;

  @override
  State<BankCallbackPasteField> createState() => _BankCallbackPasteFieldState();
}

class _BankCallbackPasteFieldState extends State<BankCallbackPasteField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          context.tr(BankSyncLocale.pasteLabel),
          controller: _controller,
          hint: context.tr(BankSyncLocale.pasteHint),
          lines: 2,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          context.tr(widget.isInvalid ? BankSyncLocale.pasteInvalid : BankSyncLocale.pasteHelp),
          style: tokens.ts(12, tokens.wBody, widget.isInvalid ? tokens.warn : tokens.muted),
        ),
        const SizedBox(height: AppSpacing.md),
        Align(
          alignment: Alignment.centerRight,
          child: AppSmallButton.primary(
            context.tr(BankSyncLocale.pasteConfirm),
            onTap: () => context.read<BankPickerCubit>().paste(_controller.text),
          ),
        ),
      ],
    );
  }
}
