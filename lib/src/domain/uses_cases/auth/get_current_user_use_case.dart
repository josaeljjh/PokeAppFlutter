import '../../../core/extensions/base/use_case.dart';
import '../../mappers/auth/app_user_mapper.dart';
import '../../model/data/auth/app_user.dart';
import '../../repository/auth/auth_repository.dart';

class GetCurrentUserUseCase implements UseCase<AppUser?, NoParams> {
  GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<AppUser?> call(NoParams params) async {
    final user = await _repository.currentUser();
    return user == null ? null : AppUserMapper().call(user);
  }
}
