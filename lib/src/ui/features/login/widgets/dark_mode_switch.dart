import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

import '../../../../core/resources/translations_constant.dart';
import '../../theme/cubit/theme_cubit.dart';

class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(
          isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
          color: isDark ? DsColors.yellow : DsColors.orange,
        ),
        const SizedBox(width: DsDimension.sm),
        Expanded(
          child: GenericLabel(
            label: DARK_MODE.i18n(),
            style: DsTypography.bodyBold.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Switch(
          value: isDark,
          onChanged: (enabled) =>
              context.read<ThemeCubit>().setDarkMode(enabled: enabled),
        ),
      ],
    );
  }
}
