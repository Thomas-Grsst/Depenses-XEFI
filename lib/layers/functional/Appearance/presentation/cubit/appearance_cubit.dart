import 'dart:async';

import 'package:depenses/layers/technical/Storage/ledger_changes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/appearance_settings.dart';
import '../../domain/use_cases/get_appearance_use_case.dart';

class AppearanceCubit extends Cubit<AppearanceSettings> {
  AppearanceCubit(this._getAppearance, LedgerChanges changes) : super(_getAppearance()) {
    _subscription = changes.changes.listen((_) => load());
  }

  final GetAppearanceUseCase _getAppearance;
  late final StreamSubscription<void> _subscription;

  void load() => emit(_getAppearance());

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
