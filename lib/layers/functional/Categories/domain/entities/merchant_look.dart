import 'package:equatable/equatable.dart';

class MerchantLook extends Equatable {
  const MerchantLook.icon(String this.icon) : letter = null;

  const MerchantLook.letter(String this.letter) : icon = null;

  final String? icon;
  final String? letter;

  bool get isLetter => letter != null;

  @override
  List<Object?> get props => [icon, letter];
}
