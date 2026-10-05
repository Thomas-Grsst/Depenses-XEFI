import 'package:depenses/layers/functional/Appearance/domain/entities/visual_style.dart';
import 'package:equatable/equatable.dart';

enum OnboardingStatus { editing, completing, completed }

class OnboardingState extends Equatable {
  const OnboardingState({
    this.status = OnboardingStatus.editing,
    this.isNameFilled = false,
    this.payDay = 1,
    this.style = VisualStyle.menthe,
  });

  final OnboardingStatus status;
  final bool isNameFilled;
  final int payDay;
  final VisualStyle style;

  bool get canStart => isNameFilled && status == OnboardingStatus.editing;

  OnboardingState copyWith({OnboardingStatus? status, bool? isNameFilled, int? payDay, VisualStyle? style}) =>
      OnboardingState(
        status: status ?? this.status,
        isNameFilled: isNameFilled ?? this.isNameFilled,
        payDay: payDay ?? this.payDay,
        style: style ?? this.style,
      );

  @override
  List<Object?> get props => [status, isNameFilled, payDay, style];
}
