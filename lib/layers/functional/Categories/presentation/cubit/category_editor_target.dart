import 'package:equatable/equatable.dart';

import '../../domain/entities/category.dart';

class CategoryEditorTarget extends Equatable {
  const CategoryEditorTarget({this.category, required this.paletteSize});

  final Category? category;
  final int paletteSize;

  @override
  List<Object?> get props => [category, paletteSize];
}
