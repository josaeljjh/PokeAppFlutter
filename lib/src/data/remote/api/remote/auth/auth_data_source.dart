import '../../../../../core/resources/data_state.dart';
import '../../../dto/auth/auth_user_dto.dart';

abstract class AuthDataSource {
  /// Usuario con sesión activa o `null` si no hay sesión.
  Future<AuthUserDto?> currentUser();

  Future<DataState<AuthUserDto>> signInWithGoogle();

  Future<void> signOut();
}
