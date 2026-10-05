import 'package:equatable/equatable.dart';

import '../../domain/entities/profile_overview.dart';

enum ProfileStatus { initial, ready }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.overview = const ProfileOverview(),
    this.exportedCsv = '',
    this.exportCount = 0,
  });

  final ProfileStatus status;
  final ProfileOverview overview;
  final String exportedCsv;
  final int exportCount;

  ProfileState copyWith({ProfileStatus? status, ProfileOverview? overview, String? exportedCsv, int? exportCount}) =>
      ProfileState(
        status: status ?? this.status,
        overview: overview ?? this.overview,
        exportedCsv: exportedCsv ?? this.exportedCsv,
        exportCount: exportCount ?? this.exportCount,
      );

  @override
  List<Object?> get props => [status, overview, exportedCsv, exportCount];
}
