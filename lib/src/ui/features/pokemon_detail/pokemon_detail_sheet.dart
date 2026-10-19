import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/resources/error_messages.dart';
import '../../../core/resources/image_routes.dart';
import '../../../core/resources/translations_constant.dart';
import '../../../domain/model/data/pokemon/pokemon.dart';
import '../../../domain/model/data/pokemon/pokemon_detail.dart';
import '../../../domain/model/ui/pokemon_detail_ui_state.dart';
import '../../widgets/feedback/message_view.dart';
import '../../widgets/pokemon/type_chip.dart';
import '../select/cubit/select_cubit.dart';
import 'cubit/pokemon_detail_cubit.dart';
import 'widgets/stat_bar.dart';

/// Detalle del pokémon en bottom sheet (migrado de `sheetDialogDetalle`).
/// Requiere un [SelectCubit] en el contexto para agregar/quitar del equipo.
class PokemonDetailSheet extends StatelessWidget {
  const PokemonDetailSheet({
    super.key,
    required this.pokemon,
    required this.region,
  });

  static Widget create({required Pokemon pokemon, required String region}) {
    return BlocProvider<PokemonDetailCubit>(
      create: (_) => sl.get<PokemonDetailCubit>()..loadDetail(pokemon.id),
      child: PokemonDetailSheet(pokemon: pokemon, region: region),
    );
  }

  final Pokemon pokemon;
  final String region;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PokemonDetailCubit>().state;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          DsDimension.lg,
          0,
          DsDimension.lg,
          DsDimension.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'pokemon-${pokemon.id}',
              child: CustomNetworkImage(
                url: state.detail?.imageUrl ?? pokemon.imageUrl,
                width: DsDimension.pokemonArtwork,
                height: DsDimension.pokemonArtwork,
              ),
            ),
            GenericLabel(
              label: pokemon.displayName,
              alignment: AlignmentDirectional.center,
              style: DsTypography.h1.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: DsDimension.md),
            _DetailBody(state: state, pokemon: pokemon, region: region),
            const SizedBox(height: DsDimension.lg),
            _Actions(pokemon: pokemon),
          ],
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.state,
    required this.pokemon,
    required this.region,
  });

  final PokemonDetailUiState state;
  final Pokemon pokemon;
  final String region;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(DsDimension.lg),
        child: CircularProgressIndicator(),
      );
    }
    final detail = state.detail;
    if (state.isError || detail == null) {
      return MessageView(
        message: errorMessage(state.errorCode, fallback: ERROR_POKEMON),
        image: img_gengar,
        actionLabel: ACTION_RETRY.i18n(),
        onAction: () =>
            context.read<PokemonDetailCubit>().loadDetail(pokemon.id),
      );
    }
    return _DetailInfo(detail: detail, pokemon: pokemon, region: region);
  }
}

class _DetailInfo extends StatelessWidget {
  const _DetailInfo({
    required this.detail,
    required this.pokemon,
    required this.region,
  });

  final PokemonDetail detail;
  final Pokemon pokemon;
  final String region;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final labelStyle =
        DsTypography.captionBold.copyWith(color: DsColors.grey40);
    final valueStyle = DsTypography.bodyBold.copyWith(color: onSurface);

    Widget row(String label, Widget value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: DsDimension.xs),
          child: Row(
            children: [
              SizedBox(
                width: 110,
                child: GenericLabel(label: label, style: labelStyle),
              ),
              Expanded(child: value),
            ],
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        row(
          DETAIL_NUMBER.i18n(),
          GenericLabel(label: '#${pokemon.entryNumber}', style: valueStyle),
        ),
        row(
          DETAIL_TYPE.i18n(),
          Wrap(
            spacing: DsDimension.xs,
            children: detail.types.map((t) => TypeChip(type: t)).toList(),
          ),
        ),
        row(DETAIL_REGION.i18n(),
            GenericLabel(label: region, style: valueStyle)),
        row(
          '${DETAIL_HEIGHT.i18n()} / ${DETAIL_WEIGHT.i18n()}',
          GenericLabel(
            label: '${detail.heightMeters} m · ${detail.weightKg} kg',
            style: valueStyle,
          ),
        ),
        if (detail.description.isNotEmpty) ...[
          const SizedBox(height: DsDimension.sm),
          GenericLabel(label: DETAIL_DESCRIPTION.i18n(), style: labelStyle),
          const SizedBox(height: DsDimension.xs),
          GenericLabel(
            label: detail.description,
            style: DsTypography.bodyRegular.copyWith(color: onSurface),
          ),
        ],
        if (detail.stats.isNotEmpty) ...[
          const SizedBox(height: DsDimension.md),
          GenericLabel(label: DETAIL_STATS.i18n(), style: labelStyle),
          const SizedBox(height: DsDimension.xs),
          ...detail.stats.map((stat) => StatBar(stat: stat)),
        ],
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final isSelected = context.select<SelectCubit, bool>(
      (cubit) => cubit.state.selectedIds.contains(pokemon.id),
    );
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(DETAIL_CLOSE.i18n()),
          ),
        ),
        const SizedBox(width: DsDimension.sm),
        Expanded(
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: isSelected ? DsColors.error : DsColors.primary,
            ),
            onPressed: () {
              context.read<SelectCubit>().toggle(pokemon);
              Navigator.pop(context);
            },
            icon: Icon(isSelected ? Icons.remove_circle : Icons.add_circle),
            label: Text(
              isSelected ? DETAIL_REMOVE.i18n() : DETAIL_ADD.i18n(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
