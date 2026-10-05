import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Forecast/domain/entities/category_stats.dart';
import 'package:equatable/equatable.dart';

enum CategoryEnvelopeStatus { untracked, untrackedWithSpending, overspent, projectedOverrun, onTrack }

class CategoryEnvelope extends Equatable {
  const CategoryEnvelope({required this.category, required this.stats});

  final Category category;
  final CategoryStats stats;

  double get spent => stats.spent;

  double get budget => stats.budget;

  double get projected => stats.projected;

  bool get hasEnvelope => budget > 0;

  bool get isProjectedOver => hasEnvelope && projected > budget;

  double get usedRatio => hasEnvelope ? spent / budget : 0;

  double get projectedRatio => hasEnvelope ? projected / budget : 0;

  double get overspentBy => spent - budget;

  double get projectedOverrun => projected - budget;

  CategoryEnvelopeStatus get status {
    if (!hasEnvelope) {
      return spent > 0 ? CategoryEnvelopeStatus.untrackedWithSpending : CategoryEnvelopeStatus.untracked;
    }
    if (spent > budget) return CategoryEnvelopeStatus.overspent;
    if (isProjectedOver) return CategoryEnvelopeStatus.projectedOverrun;
    return CategoryEnvelopeStatus.onTrack;
  }

  @override
  List<Object?> get props => [category, stats];
}
