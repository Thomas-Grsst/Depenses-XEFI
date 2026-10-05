import 'dart:async';

import 'package:depenses/layers/functional/Appearance/domain/entities/visual_style.dart';
import 'package:depenses/layers/functional/Appearance/domain/use_cases/choose_visual_style_use_case.dart';
import 'package:depenses/layers/functional/Appearance/domain/use_cases/get_appearance_use_case.dart';
import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/complete_onboarding_use_case.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._getAppearance, this._chooseStyle, this._complete, LedgerChanges changes)
    : super(OnboardingState(style: _getAppearance().style)) {
    _subscription = changes.changes.listen((_) => _refreshStyle());
  }

  final GetAppearanceUseCase _getAppearance;
  final ChooseVisualStyleUseCase _chooseStyle;
  final CompleteOnboardingUseCase _complete;
  late final StreamSubscription<void> _subscription;

  void changeName(String name) => emit(state.copyWith(isNameFilled: name.trim().isNotEmpty));

  void changePayDay(int payDay) => emit(state.copyWith(payDay: payDay));

  Future<void> chooseStyle(VisualStyle style) => _chooseStyle(style);

  Future<void> complete({required String name, required double? income, required double? balance}) async {
    if (!state.canStart) return;
    emit(state.copyWith(status: OnboardingStatus.completing));
    await _complete(name: name, income: income, payDay: state.payDay, balance: balance);
    if (!isClosed) emit(state.copyWith(status: OnboardingStatus.completed));
  }

  void _refreshStyle() {
    if (isClosed) return;
    emit(state.copyWith(style: _getAppearance().style));
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
