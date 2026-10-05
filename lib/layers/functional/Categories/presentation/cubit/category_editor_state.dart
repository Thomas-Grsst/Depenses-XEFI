import 'package:equatable/equatable.dart';

import '../../domain/entities/category.dart';

enum CategoryEditorStatus { editing, saving, closed }

class CategoryEditorState extends Equatable {
  const CategoryEditorState({
    required this.icon,
    required this.customColor,
    this.category,
    this.status = CategoryEditorStatus.editing,
    this.savedKey,
  });

  final Category? category;
  final String icon;
  final int customColor;
  final CategoryEditorStatus status;
  final String? savedKey;

  bool get isNew => category == null;

  CategoryEditorState copyWith({String? icon, int? customColor, CategoryEditorStatus? status, String? savedKey}) =>
      CategoryEditorState(
        category: category,
        icon: icon ?? this.icon,
        customColor: customColor ?? this.customColor,
        status: status ?? this.status,
        savedKey: savedKey ?? this.savedKey,
      );

  @override
  List<Object?> get props => [category, icon, customColor, status, savedKey];
}
