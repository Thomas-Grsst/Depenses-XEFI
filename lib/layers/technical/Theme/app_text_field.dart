import 'package:flutter/material.dart';

import 'app_spacing.dart';
import 'app_tokens_context.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool number;
  final int lines;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const AppTextField(
    this.label, {
    super.key,
    required this.controller,
    this.hint,
    this.lines = 1,
    this.autofocus = false,
    this.onChanged,
  }) : number = false;

  const AppTextField.number(
    this.label, {
    super.key,
    required this.controller,
    this.hint,
    this.autofocus = false,
    this.onChanged,
  }) : number = true,
       lines = 1;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final graphite = tokens.isGraphite;
    final multiline = lines > 1;
    final input = TextField(
      controller: controller,
      autofocus: autofocus,
      minLines: lines,
      maxLines: lines,
      onChanged: onChanged,
      textCapitalization: number ? TextCapitalization.none : TextCapitalization.sentences,
      keyboardType: number ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      style: tokens.ts(
        multiline ? 14 : (graphite ? 17 : 15),
        graphite ? FontWeight.w400 : FontWeight.w700,
        multiline && graphite ? tokens.body : tokens.ink,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        hintStyle: tokens.ts(15, FontWeight.w400, tokens.faint),
        filled: !graphite,
        fillColor: tokens.bg,
        contentPadding: graphite ? const EdgeInsets.symmetric(vertical: 10) : const EdgeInsets.all(14),
        enabledBorder: graphite
            ? UnderlineInputBorder(borderSide: BorderSide(color: tokens.lineStrong))
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: tokens.off, width: 1.5),
              ),
        focusedBorder: graphite
            ? UnderlineInputBorder(borderSide: BorderSide(color: tokens.ink))
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: tokens.mint, width: 1.5),
              ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(graphite ? label.toUpperCase() : label, style: tokens.label()),
        SizedBox(height: graphite ? AppSpacing.xs : 6),
        input,
      ],
    );
  }
}
