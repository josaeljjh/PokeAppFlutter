import '../../../core/extensions/base/use_case.dart';
import '../../repository/auth/auth_repository.dart';

class SignOutUseCase implements UseCase<void, NoParams> {
  SignOutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<void> call(NoParams params) => _repository.signOut();
}
