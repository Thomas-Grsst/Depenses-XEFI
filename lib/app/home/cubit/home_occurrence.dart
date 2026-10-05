import 'package:depenses/layers/functional/Categories/domain/entities/category.dart';
import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:depenses/layers/functional/Recurrences/domain/entities/occurrence.dart';
import 'package:equatable/equatable.dart';

class HomeOccurrence extends Equatable {
  const HomeOccurrence({required this.occurrence, required this.look, required this.category});

  final Occurrence occurrence;
  final MerchantLook look;
  final Category category;

  @override
  List<Object?> get props => [occurrence, look, category];
}
