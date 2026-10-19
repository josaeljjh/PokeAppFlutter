import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../../domain/model/data/team/team.dart';

class ItemTeam extends StatelessWidget {
  const ItemTeam({super.key, required this.team, required this.onTap});

  final Team team;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(DsDimension.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GenericLabel(
                      label: team.name,
                      lines: 1,
                      style: DsTypography.h3.copyWith(color: onSurface),
                    ),
                  ),
                  Icon(Icons.more_vert_rounded, color: onSurface),
                ],
              ),
              GenericLabel(
                label: '${team.region} · ${team.pokemon.length} pokémon',
                style: DsTypography.caption.copyWith(color: DsColors.grey40),
              ),
              const SizedBox(height: DsDimension.sm),
              SizedBox(
                height: 56,
                child: Row(
                  children: team.pokemon
                      .map(
                        (pokemon) => Expanded(
                          child: Tooltip(
                            message: pokemon.displayName,
                            child: CustomNetworkImage(url: pokemon.imageUrl),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
