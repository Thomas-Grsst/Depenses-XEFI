import 'package:equatable/equatable.dart';

class ProfileDetailsEntry extends Equatable {
  const ProfileDetailsEntry({required this.name, required this.balance, required this.income, required this.payDay});

  final String name;
  final String balance;
  final String income;
  final int payDay;

  @override
  List<Object?> get props => [name, balance, income, payDay];
}
