import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../../domain/model/data/pokemon/pokemon.dart';

class ItemPokemon extends StatelessWidget {
  const ItemPokemon({
    super.key,
    required this.pokemon,
    required this.isSelected,
    required this.onTap,
    required this.onInfo,
  });

  final Pokemon pokemon;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DsDimension.radiusMd),
        side: BorderSide(
          color: isSelected ? DsColors.primary : DsColors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onInfo,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(DsDimension.sm),
              child: Column(
                children: [
                  Expanded(
                    child: Hero(
                      tag: 'pokemon-${pokemon.id}',
                      child: CustomNetworkImage(url: pokemon.imageUrl),
                    ),
                  ),
                  const SizedBox(height: DsDimension.xs),
                  GenericLabel(
                    label: '#${pokemon.entryNumber}',
                    alignment: AlignmentDirectional.center,
                    style: DsTypography.small.copyWith(color: DsColors.grey40),
                  ),
                  GenericLabel(
                    label: pokemon.displayName,
                    lines: 1,
                    alignment: AlignmentDirectional.center,
                    style: DsTypography.captionBold.copyWith(color: onSurface),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              top: 0,
              end: 0,
              child: IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onInfo,
                icon: const Icon(
                  Icons.info_outline_rounded,
                  size: DsDimension.iconSm,
                  color: DsColors.grey40,
                ),
              ),
            ),
            if (isSelected)
              const PositionedDirectional(
                top: DsDimension.sm,
                start: DsDimension.sm,
                child: Icon(
                  Icons.check_circle_rounded,
                  color: DsColors.primary,
                  size: DsDimension.iconMd,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
