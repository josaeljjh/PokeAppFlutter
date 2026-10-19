import '../../../core/resources/data_state.dart';
import '../../../data/remote/dto/auth/auth_user_dto.dart';

abstract class AuthRepository {
  Future<AuthUserDto?> currentUser();

  Future<DataState<AuthUserDto>> signInWithGoogle();

  Future<void> signOut();
}
