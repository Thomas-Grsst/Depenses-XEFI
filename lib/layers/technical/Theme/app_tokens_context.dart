import 'package:flutter/material.dart';

import 'app_tokens.dart';

extension AppTokensContext on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
}
