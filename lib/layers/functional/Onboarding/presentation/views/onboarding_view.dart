import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/onboarding_form.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key, required this.onCompleted});

  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<OnboardingCubit>(),
      child: BlocListener<OnboardingCubit, OnboardingState>(
        listenWhen: (previous, current) =>
            previous.status != current.status && current.status == OnboardingStatus.completed,
        listener: (_, _) => onCompleted(),
        child: const OnboardingForm(),
      ),
    );
  }
}
