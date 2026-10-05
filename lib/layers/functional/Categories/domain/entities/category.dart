import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({
    required this.key,
    required this.name,
    required this.shortName,
    required this.icon,
    required this.colorIndex,
    this.isCustom = false,
  });

  factory Category.custom({
    required String key,
    required String name,
    required String icon,
    required int customColor,
  }) => Category(
    key: key,
    name: name,
    shortName: name.length > shortNameMaxLength ? '${name.substring(0, shortNameMaxLength - 1)}.' : name,
    icon: icon,
    colorIndex: customColorOffset + customColor,
    isCustom: true,
  );

  static const otherKey = 'aut';
  static const customColorOffset = 6;
  static const shortNameMaxLength = 8;

  final String key;
  final String name;
  final String shortName;
  final String icon;
  final int colorIndex;
  final bool isCustom;

  int get customColor => colorIndex - customColorOffset;

  @override
  List<Object?> get props => [key, name, shortName, icon, colorIndex, isCustom];
}
