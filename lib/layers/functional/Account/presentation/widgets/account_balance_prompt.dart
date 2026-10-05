import 'package:depenses/layers/technical/Localization/formatting_context.dart';
import 'package:depenses/layers/technical/Navigation/app_route.dart';
import 'package:depenses/layers/technical/Navigation/open_route.dart';
import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_panel.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';

import '../l10n/account_locale.dart';

class AccountBalancePrompt extends StatelessWidget {
  const AccountBalancePrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return AppPressable(
      onTap: () => openRoute<void>(context, AppRoute.account),
      child: tokens.isGraphite
          ? Text(context.tr(AccountLocale.enterBalanceLink), style: tokens.ts(14, FontWeight.w400, tokens.muted))
          : AppPanel(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr(AccountLocale.onYourAccount),
                          style: tokens.ts(13, FontWeight.w600, tokens.muted),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(context.tr(AccountLocale.enterBalance), style: tokens.ts(15, FontWeight.w800)),
                      ],
                    ),
                  ),
                  AppIcon('chevR', size: 18, color: tokens.muted),
                ],
              ),
            ),
    );
  }
}
