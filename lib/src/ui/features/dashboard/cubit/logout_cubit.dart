import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/base/use_case.dart';
import '../../../../domain/uses_cases/auth/sign_out_use_case.dart';

/// Emite `true` cuando la sesión se cerró.
class LogoutCubit extends Cubit<bool> {
  LogoutCubit({required this.signOutUseCase}) : super(false);

  final SignOutUseCase signOutUseCase;

  Future<void> signOut() async {
    await signOutUseCase.call(NoParams());
    emit(true);
  }
}
