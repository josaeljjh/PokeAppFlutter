import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/base/use_case.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../domain/model/ui/login_ui_state.dart';
import '../../../../domain/uses_cases/auth/sign_in_google_use_case.dart';

class LoginCubit extends Cubit<LoginUiState> {
  LoginCubit({required this.signInGoogleUseCase}) : super(const LoginUiState());

  final SignInGoogleUseCase signInGoogleUseCase;

  Future<void> signInWithGoogle() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, errorCode: null));
    final result = await signInGoogleUseCase.call(NoParams());
    if (result is DataSuccess) {
      emit(state.copyWith(isLoading: false, user: result.data));
    } else {
      emit(state.copyWith(isLoading: false, errorCode: result.error));
    }
  }

  void clearError() => emit(state.copyWith(errorCode: null));
}
