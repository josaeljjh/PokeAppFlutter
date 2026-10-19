import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../../domain/model/data/pokemon/pokemon_detail.dart';

class StatBar extends StatelessWidget {
  const StatBar({super.key, required this.stat});

  /// Valor base máximo en PokeAPI.
  static const double maxStat = 255;

  static const Map<String, String> _labels = {
    'hp': 'HP',
    'attack': 'ATK',
    'defense': 'DEF',
    'special-attack': 'SpA',
    'special-defense': 'SpD',
    'speed': 'SPD',
  };

  final PokemonStat stat;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DsDimension.xxs),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              _labels[stat.name] ?? stat.name.capitalize,
              style: DsTypography.captionBold.copyWith(color: DsColors.grey40),
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '${stat.value}',
              style: DsTypography.captionBold.copyWith(color: onSurface),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(DsDimension.radiusFull),
              child: LinearProgressIndicator(
                value: (stat.value / maxStat).clamp(0, 1),
                minHeight: 6,
                backgroundColor: DsColors.grey10,
                color: stat.value >= 90 ? DsColors.success : DsColors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
