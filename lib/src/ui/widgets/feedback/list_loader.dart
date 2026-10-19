import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class ListLoader extends StatelessWidget {
  const ListLoader({super.key, this.itemCount = 6, this.itemHeight = 72});

  final int itemCount;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(DsDimension.md),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: DsDimension.sm),
      itemBuilder: (_, __) => ShimmerLoading(height: itemHeight),
    );
  }
}
