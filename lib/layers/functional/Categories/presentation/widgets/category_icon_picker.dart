import 'package:depenses/layers/technical/Theme/app_icon.dart';
import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_spacing.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/category_icons.dart';
import '../cubit/category_editor_cubit.dart';
import '../cubit/category_editor_state.dart';

class CategoryIconPicker extends StatelessWidget {
  const CategoryIconPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return BlocBuilder<CategoryEditorCubit, CategoryEditorState>(
      builder: (context, state) {
        final accent = tokens.customSwatches[state.customColor % tokens.customSwatches.length];
        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final icon in categoryIcons)
              AppPressable(
                onTap: () => context.read<CategoryEditorCubit>().selectIcon(icon),
                child: Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: state.icon == icon ? accent.withValues(alpha: 0.18) : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: state.icon == icon ? accent : tokens.line,
                      width: state.icon == icon ? 2 : 1,
                    ),
                  ),
                  child: AppIcon(icon, size: 22, color: state.icon == icon ? accent : tokens.muted),
                ),
              ),
          ],
        );
      },
    );
  }
}
