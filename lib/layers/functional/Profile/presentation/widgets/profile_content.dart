import 'package:depenses/layers/technical/Theme/app_page_list.dart';
import 'package:depenses/layers/technical/Theme/app_tokens_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import 'profile_appearance_section.dart';
import 'profile_head.dart';
import 'profile_settings_section.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key, required this.goalsSection});

  final Widget goalsSection;

  @override
  Widget build(BuildContext context) {
    final graphite = context.tokens.isGraphite;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) => AppPageList(
        gap: graphite ? 30 : 16,
        children: [
          ProfileHead(overview: state.overview),
          goalsSection,
          ProfileAppearanceSection(appearance: state.overview.appearance),
          ProfileSettingsSection(overview: state.overview),
        ],
      ),
    );
  }
}
