import 'package:depenses/layers/functional/Categories/domain/entities/merchant_look.dart';
import 'package:equatable/equatable.dart';

class MerchantBadge extends Equatable {
  const MerchantBadge({required this.colorIndex, required this.look});

  final int colorIndex;
  final MerchantLook look;

  @override
  List<Object?> get props => [colorIndex, look];
}
