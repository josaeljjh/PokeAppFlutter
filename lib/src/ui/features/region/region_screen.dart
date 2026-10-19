import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

import '../../../core/resources/error_messages.dart';
import '../../../core/resources/image_routes.dart';
import '../../../core/resources/translations_constant.dart';
import '../../../core/routes/routes.dart';
import '../../../domain/model/data/team/team.dart';
import '../../../domain/model/ui/region_ui_state.dart';
import '../../tools/utils.dart';
import '../../widgets/feedback/list_loader.dart';
import '../../widgets/feedback/message_view.dart';
import '../../widgets/header/screen_header.dart';
import '../dashboard/cubit/bottom_nav_cubit.dart';
import '../team/cubit/team_cubit.dart';
import 'cubit/region_cubit.dart';
import 'widgets/item_region.dart';

/// Lista de regiones (migrado de `RegionFragment`). Requiere [RegionCubit]
/// provisto por el dashboard.
class RegionScreen extends StatelessWidget {
  const RegionScreen({super.key});

  Future<void> _openSelect(BuildContext context, RegionUiState state) async {
    final regionCubit = context.read<RegionCubit>();
    final teamCubit = context.read<TeamCubit>();
    final navCubit = context.read<BottomNavCubit>();
    regionCubit.clearEvents();

    final saved = await Navigator.pushNamed(
      context,
      Routes.select,
      arguments: state.selectedPokedex,
    );
    if (saved is Team && context.mounted) {
      teamCubit.loadTeams();
      navCubit.updateIndex(BottomNavCubit.teamsTab);
      showSnack(context, TEAM_SAVED.i18n(), icon: Icons.check_circle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegionCubit, RegionUiState>(
      listenWhen: (prev, curr) =>
          prev.selectedPokedex != curr.selectedPokedex ||
          prev.errorCode != curr.errorCode,
      listener: (context, state) {
        if (state.selectedPokedex != null) {
          _openSelect(context, state);
        } else if (state.errorCode != null && !state.isError) {
          showSnack(
            context,
            errorMessage(state.errorCode, fallback: ERROR_POKEMON),
          );
          context.read<RegionCubit>().clearEvents();
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            ScreenHeader(
              title: REGION_TITLE.i18n(),
              subtitle: REGION_SUBTITLE.i18n(),
              image: img_map,
            ),
            Expanded(child: _RegionBody(state: state)),
          ],
        );
      },
    );
  }
}

class _RegionBody extends StatelessWidget {
  const _RegionBody({required this.state});

  final RegionUiState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) return const ListLoader();
    if (state.isError) {
      return MessageView(
        message: errorMessage(state.errorCode, fallback: ERROR_REGIONS),
        image: img_gengar,
        actionLabel: ACTION_RETRY.i18n(),
        onAction: () => context.read<RegionCubit>().loadRegions(),
      );
    }
    return RefreshIndicator(
      onRefresh: () => context.read<RegionCubit>().loadRegions(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          DsDimension.md,
          DsDimension.sm,
          DsDimension.md,
          DsDimension.lg,
        ),
        itemCount: state.regions.length,
        separatorBuilder: (_, __) => const SizedBox(height: DsDimension.sm),
        itemBuilder: (context, index) {
          final region = state.regions[index];
          return ItemRegion(
            region: region,
            isLoading: state.loadingRegionId == region.id,
            onTap: () => context.read<RegionCubit>().selectRegion(region),
          )
              .animate(delay: (40 * index).ms)
              .fadeIn(duration: 250.ms)
              .slideY(begin: -0.2);
        },
      ),
    );
  }
}
