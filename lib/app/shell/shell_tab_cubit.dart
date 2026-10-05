import 'package:flutter_bloc/flutter_bloc.dart';

import 'shell_tab.dart';

class ShellTabCubit extends Cubit<ShellTab> {
  ShellTabCubit() : super(ShellTab.home);

  void select(ShellTab tab) => emit(tab);
}
