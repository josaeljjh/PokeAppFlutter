import 'package:poke_app/src/core/extensions/base/use_case.dart';
import 'package:poke_app/src/domain/model/data/auth/app_user.dart';
import 'package:poke_app/src/domain/uses_cases/auth/get_current_user_use_case.dart';
import 'package:poke_app/src/ui/features/init/cubit/splash_cubit.dart';

import '../../../helpers/test_helpers.dart';

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

void main() {
  late MockGetCurrentUserUseCase getCurrentUser;

  setUpAll(() => registerFallbackValue(NoParams()));

  setUp(() => getCurrentUser = MockGetCurrentUserUseCase());

  SplashCubit build() => SplashCubit(
        getCurrentUserUseCase: getCurrentUser,
        delay: Duration.zero,
      );

  blocTest<SplashCubit, SplashStatus>(
    'con sesión emite authenticated',
    build: () {
      when(() => getCurrentUser.call(any()))
          .thenAnswer((_) async => const AppUser(uid: 'u1'));
      return build();
    },
    act: (cubit) => cubit.checkSession(),
    expect: () => [SplashStatus.authenticated],
  );

  blocTest<SplashCubit, SplashStatus>(
    'sin sesión emite unauthenticated',
    build: () {
      when(() => getCurrentUser.call(any())).thenAnswer((_) async => null);
      return build();
    },
    act: (cubit) => cubit.checkSession(),
    expect: () => [SplashStatus.unauthenticated],
  );
}
