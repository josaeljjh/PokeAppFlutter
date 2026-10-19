import 'package:poke_app/src/core/extensions/base/use_case.dart';
import 'package:poke_app/src/core/resources/data_state.dart';
import 'package:poke_app/src/domain/model/data/auth/app_user.dart';
import 'package:poke_app/src/domain/model/ui/login_ui_state.dart';
import 'package:poke_app/src/domain/uses_cases/auth/sign_in_google_use_case.dart';
import 'package:poke_app/src/ui/features/login/cubit/login_cubit.dart';

import '../../../helpers/test_helpers.dart';

class MockSignInGoogleUseCase extends Mock implements SignInGoogleUseCase {}

void main() {
  late MockSignInGoogleUseCase signIn;
  const user = AppUser(uid: 'u1', displayName: 'Ash');

  setUpAll(() => registerFallbackValue(NoParams()));

  setUp(() => signIn = MockSignInGoogleUseCase());

  blocTest<LoginCubit, LoginUiState>(
    'signInWithGoogle emite [loading] → [user]',
    build: () {
      when(() => signIn.call(any()))
          .thenAnswer((_) async => const DataSuccess(data: user));
      return LoginCubit(signInGoogleUseCase: signIn);
    },
    act: (cubit) => cubit.signInWithGoogle(),
    expect: () => const [
      LoginUiState(isLoading: true),
      LoginUiState(user: user),
    ],
  );

  blocTest<LoginCubit, LoginUiState>(
    'signInWithGoogle emite errorCode en fallo',
    build: () {
      when(() => signIn.call(any()))
          .thenAnswer((_) async => const DataError(error: 'sign_in_cancelled'));
      return LoginCubit(signInGoogleUseCase: signIn);
    },
    act: (cubit) => cubit.signInWithGoogle(),
    expect: () => const [
      LoginUiState(isLoading: true),
      LoginUiState(errorCode: 'sign_in_cancelled'),
    ],
  );
}
