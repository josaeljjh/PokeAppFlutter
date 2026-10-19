import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/auth/app_user.dart';

part 'login_ui_state.freezed.dart';

@freezed
abstract class LoginUiState with _$LoginUiState {
  const factory LoginUiState({
    @Default(false) bool isLoading,
    AppUser? user,
    String? errorCode,
  }) = _LoginUiState;
}
