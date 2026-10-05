import 'package:equatable/equatable.dart';

class AppSessionState extends Equatable {
  const AppSessionState({required this.isOnboarded});

  final bool isOnboarded;

  @override
  List<Object?> get props => [isOnboarded];
}
