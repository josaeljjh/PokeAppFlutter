import 'package:poke_app/src/core/extensions/base/use_case.dart';
import 'package:poke_app/src/core/resources/data_state.dart';
import 'package:poke_app/src/data/remote/dto/auth/auth_user_dto.dart';
import 'package:poke_app/src/domain/model/data/auth/app_user.dart';
import 'package:poke_app/src/domain/repository/auth/auth_repository.dart';
import 'package:poke_app/src/domain/uses_cases/auth/get_current_user_use_case.dart';
import 'package:poke_app/src/domain/uses_cases/auth/sign_in_google_use_case.dart';
import 'package:poke_app/src/domain/uses_cases/auth/sign_out_use_case.dart';

import '../../../helpers/test_helpers.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  const dto = AuthUserDto(uid: 'u1', displayName: 'Ash', email: null);

  setUp(() => repository = MockAuthRepository());

  test('GetCurrentUserUseCase mapea el usuario', () async {
    when(() => repository.currentUser()).thenAnswer((_) async => dto);

    final user = await GetCurrentUserUseCase(repository).call(NoParams());

    expect(user, const AppUser(uid: 'u1', displayName: 'Ash'));
  });

  test('GetCurrentUserUseCase devuelve null sin sesión', () async {
    when(() => repository.currentUser()).thenAnswer((_) async => null);

    expect(await GetCurrentUserUseCase(repository).call(NoParams()), isNull);
  });

  test('SignInGoogleUseCase propaga el error', () async {
    when(() => repository.signInWithGoogle())
        .thenAnswer((_) async => const DataError(error: 'sign_in_cancelled'));

    final result = await SignInGoogleUseCase(repository).call(NoParams());

    expect(result.error, 'sign_in_cancelled');
  });

  test('SignOutUseCase delega en el repositorio', () async {
    when(() => repository.signOut()).thenAnswer((_) async {});

    await SignOutUseCase(repository).call(NoParams());

    verify(() => repository.signOut()).called(1);
  });
}
