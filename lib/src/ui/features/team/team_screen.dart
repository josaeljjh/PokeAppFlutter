import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/resources/error_messages.dart';
import '../../../core/resources/image_routes.dart';
import '../../../core/resources/translations_constant.dart';
import '../../../domain/model/data/team/team.dart';
import '../../../domain/model/ui/team_ui_state.dart';
import '../../tools/utils.dart';
import '../../widgets/feedback/list_loader.dart';
import '../../widgets/feedback/message_view.dart';
import '../../widgets/header/screen_header.dart';
import '../dashboard/cubit/bottom_nav_cubit.dart';
import '../select/widgets/team_name_dialog.dart';
import 'cubit/team_cubit.dart';
import 'widgets/item_team.dart';
import 'widgets/team_options_sheet.dart';

/// Equipos guardados (migrado de `TeamFragment`). Requiere [TeamCubit]
/// provisto por el dashboard.
class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  Future<void> _openOptions(BuildContext context, Team team) async {
    final cubit = context.read<TeamCubit>();
    final option = await dialogBottomSheet<TeamOption>(
      context: context,
      child: TeamOptionsSheet(team: team),
    );
    if (!context.mounted || option == null) return;

    switch (option) {
      case TeamOption.share:
        await Share.share(
          TEAM_SHARE_TEXT.i18n([
            team.name,
            team.region,
            team.pokemon.map((p) => p.displayName).join(', '),
          ]),
        );
      case TeamOption.rename:
        final name = await showTeamNameDialog(
          context,
          title: TEAM_RENAME.i18n(),
          initialValue: team.name,
        );
        if (name != null) await cubit.rename(team, name);
      case TeamOption.delete:
        final confirmed = await _confirmDelete(context, team);
        if (confirmed && context.mounted) {
          await cubit.delete(team);
          if (context.mounted) showSnack(context, TEAM_DELETED.i18n());
        }
    }
  }

  Future<bool> _confirmDelete(BuildContext context, Team team) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Text(TEAM_DELETE_CONFIRM.i18n([team.name])),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(ACTION_CANCEL.i18n()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(ACTION_DELETE.i18n()),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeamCubit, TeamUiState>(
      listenWhen: (prev, curr) =>
          prev.errorCode != curr.errorCode && curr.errorCode != null,
      listener: (context, state) {
        if (!state.isError) {
          showSnack(context, errorMessage(state.errorCode));
          context.read<TeamCubit>().clearError();
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            ScreenHeader(title: TEAM_TITLE.i18n(), image: img_pokeballs),
            Expanded(child: _buildBody(context, state)),
          ],
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, TeamUiState state) {
    if (state.isLoading) return const ListLoader(itemHeight: 120);
    if (state.isError) {
      return MessageView(
        message: errorMessage(state.errorCode),
        image: img_gengar,
        actionLabel: ACTION_RETRY.i18n(),
        onAction: () => context.read<TeamCubit>().loadTeams(),
      );
    }
    if (state.teams.isEmpty) {
      return MessageView(
        message: TEAM_EMPTY.i18n(),
        image: img_gengar,
        actionLabel: TEAM_CREATE.i18n(),
        onAction: () => context
            .read<BottomNavCubit>()
            .updateIndex(BottomNavCubit.regionTab),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        DsDimension.md,
        DsDimension.sm,
        DsDimension.md,
        DsDimension.lg,
      ),
      itemCount: state.teams.length,
      separatorBuilder: (_, __) => const SizedBox(height: DsDimension.sm),
      itemBuilder: (context, index) {
        final team = state.teams[index];
        return ItemTeam(
          team: team,
          onTap: () => _openOptions(context, team),
        ).animate(delay: (40 * index).ms).fadeIn().slideY(begin: -0.2);
      },
    );
  }
}
