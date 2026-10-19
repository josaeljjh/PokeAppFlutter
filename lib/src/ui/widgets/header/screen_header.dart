import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Encabezado con imagen (equivale a los collapsing headers del Android).
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    required this.image,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DsDimension.md,
        DsDimension.md,
        DsDimension.md,
        DsDimension.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GenericLabel(
                  label: title,
                  style: DsTypography.h1.copyWith(color: onSurface),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: DsDimension.xs),
                  GenericLabel(
                    label: subtitle!,
                    style: DsTypography.caption.copyWith(
                      color: DsColors.grey40,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Image.asset(image, width: 64, height: 64),
        ],
      ),
    );
  }
}
