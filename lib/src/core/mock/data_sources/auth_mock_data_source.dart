import '../../../data/remote/api/remote/auth/auth_data_source.dart';
import '../../../data/remote/dto/auth/auth_user_dto.dart';
import '../../resources/data_state.dart';

/// Sesión en memoria: cada arranque inicia sin sesión.
class AuthMockDataSource implements AuthDataSource {
  AuthUserDto? _user;

  @override
  Future<AuthUserDto?> currentUser() async => _user;

  @override
  Future<DataState<AuthUserDto>> signInWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _user = const AuthUserDto(
      uid: 'mock-uid',
      displayName: 'Ash Ketchum',
      email: 'ash@pokeapp.test',
    );
    return DataSuccess(data: _user!);
  }

  @override
  Future<void> signOut() async => _user = null;
}
