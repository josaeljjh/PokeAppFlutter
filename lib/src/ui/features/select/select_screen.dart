import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/resources/error_messages.dart';
import '../../../core/resources/translations_constant.dart';
import '../../../domain/model/data/pokemon/pokemon.dart';
import '../../../domain/model/ui/select_ui_state.dart';
import '../../tools/utils.dart';
import '../pokemon_detail/pokemon_detail_sheet.dart';
import 'cubit/select_cubit.dart';
import 'widgets/item_pokemon.dart';
import 'widgets/save_team_bar.dart';
import 'widgets/team_name_dialog.dart';

/// Selección de pokémon para armar un equipo (migrado de `SelectFragment`).
/// Devuelve el `Team` guardado al hacer pop.
class SelectScreen extends StatelessWidget {
  const SelectScreen({super.key});

  static Widget create(BuildContext context, RegionPokedex pokedex) {
    return BlocProvider<SelectCubit>(
      create: (_) => sl.get<SelectCubit>(param1: pokedex),
      child: const SelectScreen(),
    );
  }

  Future<void> _askTeamName(BuildContext context) async {
    final cubit = context.read<SelectCubit>();
    final name = await showTeamNameDialog(
      context,
      title: SELECT_SAVE.i18n(),
      initialValue: cubit.state.pokedex.region.displayName,
    );
    if (name != null) await cubit.saveTeam(name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectCubit, SelectUiState>(
      listenWhen: (prev, curr) =>
          prev.savedTeam != curr.savedTeam || prev.errorCode != curr.errorCode,
      listener: (context, state) {
        if (state.savedTeam != null) {
          Navigator.pop(context, state.savedTeam);
        } else if (state.errorCode != null) {
          showSnack(context, errorMessage(state.errorCode));
          context.read<SelectCubit>().clearError();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(SELECT_TITLE.i18n()),
        ),
        body: const _SelectBody(),
        bottomNavigationBar: Builder(
          builder: (context) {
            final state = context.watch<SelectCubit>().state;
            return SaveTeamBar(
              selected: state.selectedIds.length,
              canSave: context.read<SelectCubit>().canSave,
              isSaving: state.isSaving,
              onSave: () => _askTeamName(context),
            );
          },
        ),
      ),
    );
  }
}

class _SelectBody extends StatelessWidget {
  const _SelectBody();

  void _openDetail(BuildContext context, Pokemon pokemon) {
    final cubit = context.read<SelectCubit>();
    dialogBottomSheet<void>(
      context: context,
      child: BlocProvider.value(
        value: cubit,
        child: PokemonDetailSheet.create(
          pokemon: pokemon,
          region: cubit.state.pokedex.region.displayName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SelectCubit>().state;
    final cubit = context.read<SelectCubit>();
    final pokemon = state.visiblePokemon;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(DsDimension.md),
            child: Column(
              children: [
                GenericLabel(
                  label: state.pokedex.region.displayName,
                  style: DsTypography.h2.copyWith(color: DsColors.primary),
                ),
                const SizedBox(height: DsDimension.xs),
                GenericLabel(
                  label: SELECT_RULES.i18n(),
                  style: DsTypography.caption.copyWith(color: DsColors.grey40),
                ),
                const SizedBox(height: DsDimension.md),
                TextField(
                  onChanged: cubit.search,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: SELECT_SEARCH.i18n(),
                    prefixIcon: const Icon(Icons.search_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DsDimension.radiusMd),
                    ),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            DsDimension.md,
            0,
            DsDimension.md,
            DsDimension.lg,
          ),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 140,
              mainAxisSpacing: DsDimension.sm,
              crossAxisSpacing: DsDimension.sm,
              childAspectRatio: 0.8,
            ),
            itemCount: pokemon.length,
            itemBuilder: (context, index) {
              final item = pokemon[index];
              return ItemPokemon(
                pokemon: item,
                isSelected: state.selectedIds.contains(item.id),
                onTap: () => cubit.toggle(item),
                onInfo: () => _openDetail(context, item),
              );
            },
          ),
        ),
      ],
    );
  }
}
