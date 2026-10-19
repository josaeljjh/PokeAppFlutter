import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../../../core/resources/translations_constant.dart';
import '../../../../domain/model/data/team/team.dart';

enum TeamOption { share, rename, delete }

/// Opciones de equipo (migrado del menú de `collapsing_team_end`).
class TeamOptionsSheet extends StatelessWidget {
  const TeamOptionsSheet({super.key, required this.team});

  final Team team;

  @override
  Widget build(BuildContext context) {
    Widget option(TeamOption value, IconData icon, String label,
            {Color? color}) =>
        ListTile(
          leading: Icon(icon, color: color),
          title: Text(label, style: TextStyle(color: color)),
          onTap: () => Navigator.pop(context, value),
        );

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GenericLabel(
            label: team.name,
            alignment: AlignmentDirectional.center,
            style: DsTypography.h3.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: DsDimension.sm),
          option(TeamOption.share, Icons.share_rounded, TEAM_SHARE.i18n()),
          option(TeamOption.rename, Icons.edit_rounded, TEAM_EDIT_NAME.i18n()),
          option(
            TeamOption.delete,
            Icons.delete_rounded,
            TEAM_DELETE.i18n(),
            color: DsColors.error,
          ),
          const SizedBox(height: DsDimension.sm),
        ],
      ),
    );
  }
}
