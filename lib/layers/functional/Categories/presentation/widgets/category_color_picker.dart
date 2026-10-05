import 'package:depenses/layers/technical/Theme/app_pressable.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/category_editor_cubit.dart';
import '../cubit/category_editor_state.dart';

class CategoryColorPicker extends StatelessWidget {
  const CategoryColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final swatches = tokens.customSwatches;
    return BlocBuilder<CategoryEditorCubit, CategoryEditorState>(
      buildWhen: (previous, current) => previous.customColor != current.customColor,
      builder: (context, state) => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (var index = 0; index < swatches.length; index++)
            AppPressable(
              onTap: () => context.read<CategoryEditorCubit>().selectColor(index),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: swatches[index],
                  shape: BoxShape.circle,
                  border: Border.all(color: state.customColor == index ? tokens.ink : Colors.transparent, width: 2.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
