import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/image_routes.dart';
import '../../../../domain/model/data/region/region.dart';

class ItemRegion extends StatelessWidget {
  const ItemRegion({
    super.key,
    required this.region,
    required this.onTap,
    this.isLoading = false,
  });

  final Region region;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(DsDimension.md),
          child: Row(
            children: [
              Image.asset(img_pokeball, width: 40, height: 40),
              const SizedBox(width: DsDimension.md),
              Expanded(
                child: GenericLabel(
                  label: region.displayName,
                  style: DsTypography.h3.copyWith(color: onSurface),
                ),
              ),
              if (isLoading)
                const SizedBox.square(
                  dimension: DsDimension.iconMd,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(Icons.chevron_right_rounded, color: onSurface),
            ],
          ),
        ),
      ),
    );
  }
}
