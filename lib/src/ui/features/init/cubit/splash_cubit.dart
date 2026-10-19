import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/base/use_case.dart';
import '../../../../domain/uses_cases/auth/get_current_user_use_case.dart';

enum SplashStatus { loading, authenticated, unauthenticated }

class SplashCubit extends Cubit<SplashStatus> {
  SplashCubit({
    required this.getCurrentUserUseCase,
    this.delay = const Duration(seconds: 1),
  }) : super(SplashStatus.loading);

  final GetCurrentUserUseCase getCurrentUserUseCase;
  final Duration delay;

  Future<void> checkSession() async {
    await Future<void>.delayed(delay);
    final user = await getCurrentUserUseCase.call(NoParams());
    emit(user == null
        ? SplashStatus.unauthenticated
        : SplashStatus.authenticated);
  }
}
