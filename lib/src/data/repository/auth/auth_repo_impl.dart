import '../../../core/resources/data_state.dart';
import '../../../domain/repository/auth/auth_repository.dart';
import '../../remote/api/remote/auth/auth_data_source.dart';
import '../../remote/dto/auth/auth_user_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.dataSource);

  final AuthDataSource dataSource;

  @override
  Future<AuthUserDto?> currentUser() => dataSource.currentUser();

  @override
  Future<DataState<AuthUserDto>> signInWithGoogle() =>
      dataSource.signInWithGoogle();

  @override
  Future<void> signOut() => dataSource.signOut();
}
