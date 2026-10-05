import 'package:depenses/layers/functional/Appearance/domain/entities/visual_style.dart';
import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Theme/app_button.dart';
import 'package:depenses/layers/technical/Theme/app_section_label.dart';
import 'package:depenses/layers/technical/Theme/app_segmented.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../l10n/onboarding_locale.dart';
import 'onboarding_fields.dart';
import 'onboarding_intro.dart';
import 'onboarding_pay_day_picker.dart';

class OnboardingForm extends StatefulWidget {
  const OnboardingForm({super.key});

  @override
  State<OnboardingForm> createState() => _OnboardingFormState();
}

class _OnboardingFormState extends State<OnboardingForm> {
  final _name = TextEditingController();
  final _income = TextEditingController();
  final _balance = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _income.dispose();
    _balance.dispose();
    super.dispose();
  }

  void _start(OnboardingCubit cubit) => cubit.complete(
    name: _name.text,
    income: context.money.parse(_income.text),
    balance: context.money.parse(_balance.text),
  );

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final cubit = context.read<OnboardingCubit>();
    return Scaffold(
      backgroundColor: tokens.bg,
      body: SafeArea(
        child: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) => ListView(
            padding: EdgeInsets.fromLTRB(tokens.pad, 48, tokens.pad, 24),
            children: [
              const OnboardingIntro(),
              const SizedBox(height: 36),
              OnboardingFields(name: _name, balance: _balance, income: _income, onNameChanged: cubit.changeName),
              const SizedBox(height: 18),
              OnboardingPayDayPicker(value: state.payDay, onChanged: cubit.changePayDay),
              const SizedBox(height: 32),
              AppSectionLabel(context.tr(OnboardingLocale.style)),
              const SizedBox(height: 10),
              AppSegmented<VisualStyle>(
                options: [
                  (VisualStyle.menthe, context.tr(OnboardingLocale.styleMenthe)),
                  (VisualStyle.graphite, context.tr(OnboardingLocale.styleGraphite)),
                ],
                value: state.style,
                onChanged: cubit.chooseStyle,
              ),
              const SizedBox(height: 40),
              AppButton.primary(context.tr(OnboardingLocale.start), onTap: state.canStart ? () => _start(cubit) : null),
            ],
          ),
        ),
      ),
    );
  }
}
