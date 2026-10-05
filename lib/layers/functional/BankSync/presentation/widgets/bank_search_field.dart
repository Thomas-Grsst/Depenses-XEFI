import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/bank_picker_cubit.dart';
import '../l10n/bank_sync_locale.dart';

class BankSearchField extends StatefulWidget {
  const BankSearchField({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  State<BankSearchField> createState() => _BankSearchFieldState();
}

class _BankSearchFieldState extends State<BankSearchField> {
  late final TextEditingController _controller = TextEditingController(text: widget.initialQuery);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      context.tr(BankSyncLocale.searchLabel),
      controller: _controller,
      hint: context.tr(BankSyncLocale.searchHint),
      onChanged: context.read<BankPickerCubit>().search,
    );
  }
}
