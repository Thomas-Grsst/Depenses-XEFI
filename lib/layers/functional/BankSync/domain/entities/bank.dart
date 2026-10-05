import 'package:equatable/equatable.dart';

class Bank extends Equatable {
  const Bank({required this.name, required this.country, this.logoUrl, this.maximumConsentValidity});

  static const defaultConsentValidity = Duration(days: 90);

  final String name;
  final String country;
  final String? logoUrl;
  final Duration? maximumConsentValidity;

  Duration get consentValidity => maximumConsentValidity ?? defaultConsentValidity;

  @override
  List<Object?> get props => [name, country, logoUrl, maximumConsentValidity];
}
