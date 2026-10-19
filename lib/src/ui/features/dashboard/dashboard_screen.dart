import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/resources/translations_constant.dart';
import '../../../core/routes/routes.dart';
import '../region/cubit/region_cubit.dart';
import '../region/region_screen.dart';
import '../team/cubit/team_cubit.dart';
import '../team/team_screen.dart';
import 'cubit/bottom_nav_cubit.dart';
import 'cubit/logout_cubit.dart';

/// Contenedor con navegación inferior (migrado de `HomeHost`).
class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  static Widget create(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavCubit>(create: (_) => BottomNavCubit()),
        BlocProvider<LogoutCubit>(create: (_) => sl.get<LogoutCubit>()),
        BlocProvider<RegionCubit>(
          create: (_) => sl.get<RegionCubit>()..loadRegions(),
        ),
        BlocProvider<TeamCubit>(
          create: (_) => sl.get<TeamCubit>()..loadTeams(),
        ),
      ],
      child: const DashBoardScreen(),
    );
  }

  static const _logoutIndex = 2;

  @override
  Widget build(BuildContext context) {
    final index = context.watch<BottomNavCubit>().state;
    return BlocListener<LogoutCubit, bool>(
      listener: (context, loggedOut) {
        if (loggedOut) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.login,
            (_) => false,
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: index,
            children: const [RegionScreen(), TeamScreen()],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (selected) {
            if (selected == _logoutIndex) {
              context.read<LogoutCubit>().signOut();
              return;
            }
            context.read<BottomNavCubit>().updateIndex(selected);
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.map_outlined),
              selectedIcon: const Icon(Icons.map),
              label: NAV_REGION.i18n(),
            ),
            NavigationDestination(
              icon: const Icon(Icons.catching_pokemon_outlined),
              selectedIcon: const Icon(Icons.catching_pokemon),
              label: NAV_TEAMS.i18n(),
            ),
            NavigationDestination(
              icon: const Icon(Icons.logout_rounded),
              label: NAV_LOGOUT.i18n(),
            ),
          ],
        ),
      ),
    );
  }
}
