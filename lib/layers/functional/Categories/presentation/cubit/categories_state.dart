import 'package:equatable/equatable.dart';

import '../../domain/entities/category.dart';

class CategoriesState extends Equatable {
  const CategoriesState({this.categories = const []});

  final List<Category> categories;

  CategoriesState copyWith({List<Category>? categories}) => CategoriesState(categories: categories ?? this.categories);

  @override
  List<Object?> get props => [categories];
}
