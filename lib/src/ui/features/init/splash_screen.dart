import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/resources/image_routes.dart';
import '../../../core/routes/routes.dart';
import 'cubit/splash_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static Widget create(BuildContext context) {
    return BlocProvider<SplashCubit>(
      create: (_) => sl.get<SplashCubit>()..checkSession(),
      child: const SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashStatus>(
      listener: (context, status) {
        switch (status) {
          case SplashStatus.authenticated:
            Navigator.pushReplacementNamed(context, Routes.dashboard);
          case SplashStatus.unauthenticated:
            Navigator.pushReplacementNamed(context, Routes.login);
          case SplashStatus.loading:
            break;
        }
      },
      child: Scaffold(
        backgroundColor: DsColors.primary,
        body: Center(
          child: Image.asset(
            img_pokemon_logo,
            width: DsDimension.logoWidth,
          ).animate().fadeIn(duration: 500.ms).scale(
                begin: const Offset(0.8, 0.8),
                curve: Curves.easeOutBack,
              ),
        ),
      ),
    );
  }
}
