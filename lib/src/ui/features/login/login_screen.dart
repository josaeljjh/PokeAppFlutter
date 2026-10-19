import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/resources/error_messages.dart';
import '../../../core/resources/image_routes.dart';
import '../../../core/resources/translations_constant.dart';
import '../../../core/routes/routes.dart';
import '../../../domain/model/ui/login_ui_state.dart';
import '../../tools/utils.dart';
import 'cubit/login_cubit.dart';
import 'widgets/dark_mode_switch.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static Widget create(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => sl.get<LoginCubit>(),
      child: const LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginUiState>(
      listenWhen: (prev, curr) =>
          prev.user != curr.user || prev.errorCode != curr.errorCode,
      listener: (context, state) {
        if (state.user != null) {
          Navigator.pushReplacementNamed(context, Routes.dashboard);
        } else if (state.errorCode != null) {
          showSnack(
            context,
            errorMessage(state.errorCode),
            icon: Icons.wifi_off_rounded,
          );
          context.read<LoginCubit>().clearError();
        }
      },
      child: const Scaffold(body: SafeArea(child: _LoginContent())),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final isLoading =
        context.select<LoginCubit, bool>((cubit) => cubit.state.isLoading);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(DsDimension.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              img_pokemon_logo,
              width: DsDimension.logoWidth,
              height: DsDimension.logoHeight,
            ),
            Image.asset(
              img_player,
              width: DsDimension.avatar,
              height: DsDimension.avatar,
            ),
            const SizedBox(height: DsDimension.xxl),
            SizedBox(
              width: DsDimension.buttonWidth,
              child: Column(
                children: [
                  GenericLabel(
                    label: LOGIN_WELCOME.i18n(),
                    style: DsTypography.h2.copyWith(color: onSurface),
                  ),
                  GenericLabel(
                    label: LOGIN_SUBTITLE.i18n(),
                    style: DsTypography.caption.copyWith(
                      color: DsColors.grey40,
                    ),
                  ),
                  const SizedBox(height: DsDimension.lg),
                  BasicFilledButton(
                    label: LOGIN_FACEBOOK.i18n(),
                    color: DsColors.facebook,
                    icon: const Icon(Icons.facebook, color: DsColors.white),
                    onPressed: () =>
                        showSnack(context, LOGIN_FACEBOOK_SOON.i18n()),
                  ),
                  const SizedBox(height: DsDimension.sm),
                  BasicFilledButton(
                    label: LOGIN_GOOGLE.i18n(),
                    color: DsColors.google,
                    isLoading: isLoading,
                    icon: const Icon(
                      Icons.g_mobiledata_rounded,
                      color: DsColors.white,
                      size: DsDimension.iconLg,
                    ),
                    onPressed: () =>
                        context.read<LoginCubit>().signInWithGoogle(),
                  ),
                  const SizedBox(height: DsDimension.md),
                  const DarkModeSwitch(),
                ],
              ),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05),
      ),
    );
  }
}
