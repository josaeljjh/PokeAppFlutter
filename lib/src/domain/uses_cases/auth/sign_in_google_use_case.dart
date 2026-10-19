import '../../../core/extensions/base/use_case.dart';
import '../../../core/resources/data_state.dart';
import '../../mappers/auth/app_user_mapper.dart';
import '../../model/data/auth/app_user.dart';
import '../../repository/auth/auth_repository.dart';

class SignInGoogleUseCase implements UseCase<DataState<AppUser>, NoParams> {
  SignInGoogleUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<DataState<AppUser>> call(NoParams params) async {
    final result = await _repository.signInWithGoogle();
    if (result is DataSuccess) {
      return DataSuccess(data: AppUserMapper().call(result.data!));
    }
    return DataError(error: result.error ?? 'Unknown error');
  }
}
