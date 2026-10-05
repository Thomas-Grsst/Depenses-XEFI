import 'package:equatable/equatable.dart';

class CategoryMove extends Equatable {
  const CategoryMove({required this.categoryKey, required this.current, required this.previous});

  final String categoryKey;
  final double current;
  final double previous;

  double get delta => current - previous;

  double? get ratio => previous > 0 ? current / previous - 1 : null;

  @override
  List<Object?> get props => [categoryKey, current, previous];
}
