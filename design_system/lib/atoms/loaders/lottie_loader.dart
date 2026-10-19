import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Loader Lottie migrado de `assets/progress-bar.json`.
class LottieLoader extends StatelessWidget {
  const LottieLoader({super.key, this.size = 120});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'res/lottie/progress-bar.json',
      package: 'design_system',
      width: size,
      height: size,
    );
  }
}
