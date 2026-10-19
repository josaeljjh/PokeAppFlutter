import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../tokens/colors.dart';
import '../../tokens/dimensions.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 64,
    this.radius = DsDimension.radiusMd,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? DsColors.darkSurface : DsColors.grey10,
      highlightColor: isDark ? DsColors.darkCard : DsColors.grey3,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: DsColors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
