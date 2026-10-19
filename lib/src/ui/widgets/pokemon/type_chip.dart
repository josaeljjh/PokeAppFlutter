import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class TypeChip extends StatelessWidget {
  const TypeChip({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DsDimension.sm + DsDimension.xs,
        vertical: DsDimension.xs,
      ),
      decoration: BoxDecoration(
        color: DsColors.pokemonType(type),
        borderRadius: BorderRadius.circular(DsDimension.radiusFull),
      ),
      child: Text(
        type.capitalize,
        style: DsTypography.small.copyWith(color: DsColors.white),
      ),
    );
  }
}
