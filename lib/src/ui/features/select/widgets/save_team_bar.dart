import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../../../core/resources/translations_constant.dart';
import '../../../../core/tools/const.dart';

class SaveTeamBar extends StatelessWidget {
  const SaveTeamBar({
    super.key,
    required this.selected,
    required this.canSave,
    required this.isSaving,
    required this.onSave,
  });

  final int selected;
  final bool canSave;
  final bool isSaving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DsDimension.md,
            vertical: DsDimension.sm,
          ),
          // `Scaffold.bottomNavigationBar` hands its child a loose but
          // *finite* height constraint (the remaining screen space below
          // the AppBar). `GenericLabel`'s inner `Align` only shrinks to fit
          // when a constraint is truly infinite, so inside a bare `Row` it
          // would greedily fill that whole finite height, ballooning this
          // bar to cover nearly the entire screen and starving `body` of
          // space. `IntrinsicHeight` forces the `Row` (and therefore the
          // `Align`) to size to its children's natural height instead.
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: GenericLabel(
                    label: SELECT_COUNT.i18n(['$selected', '$maxTeamSize']),
                    style: DsTypography.bodyBold.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                BasicFilledButton(
                  label: SELECT_SAVE.i18n(),
                  width: 170,
                  isLoading: isSaving,
                  icon: const Icon(Icons.save_rounded, color: DsColors.white),
                  onPressed: canSave ? onSave : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
