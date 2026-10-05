import 'package:depenses/layers/functional/Appearance/domain/entities/visual_style.dart';
import 'package:depenses/layers/functional/Appearance/domain/use_cases/get_appearance_use_case.dart';
import 'package:depenses/layers/functional/Onboarding/onboarding_dependencies.dart';
import 'package:depenses/layers/functional/Onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:depenses/layers/functional/Onboarding/presentation/cubit/onboarding_state.dart';
import 'package:depenses/layers/functional/Profile/domain/use_cases/get_profile_name_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/test_dependencies.dart';

void main() {
  late TestDependencies dependencies;
  late OnboardingCubit cubit;

  setUp(() {
    dependencies = TestDependencies(today: DateTime(2026, 10, 15));
    registerOnboardingDependencies(dependencies.getIt);
    cubit = dependencies.get<OnboardingCubit>();
  });
  tearDown(() async {
    await cubit.close();
    await dependencies.dispose();
  });

  test('cannot start before a name is typed', () async {
    expect(cubit.state.canStart, isFalse);

    await cubit.complete(name: '', income: null, balance: null);
    expect(cubit.state.status, OnboardingStatus.editing);

    cubit.changeName('  Camille ');
    expect(cubit.state.canStart, isTrue);
  });

  test('the pay day is kept in the form state', () {
    cubit.changePayDay(31);

    expect(cubit.state.payDay, 31);
  });

  test('choosing a style saves it right away', () async {
    await cubit.chooseStyle(VisualStyle.graphite);

    expect(dependencies.get<GetAppearanceUseCase>()().style, VisualStyle.graphite);
    expect(cubit.state.style, VisualStyle.graphite);
  });

  test('completing saves the profile and reports completion', () async {
    cubit
      ..changeName('Camille')
      ..changePayDay(5);

    await cubit.complete(name: ' Camille ', income: 2000, balance: 100);

    expect(cubit.state.status, OnboardingStatus.completed);
    expect(dependencies.get<GetProfileNameUseCase>()(), 'Camille');
  });
}
