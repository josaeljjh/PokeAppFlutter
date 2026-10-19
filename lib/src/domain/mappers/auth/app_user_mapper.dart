import 'package:design_system/design_system.dart';

import '../../../data/remote/dto/auth/auth_user_dto.dart';
import '../../model/data/auth/app_user.dart';
import '../mapper.dart';

class AppUserMapper extends Mapper<AuthUserDto, AppUser> {
  @override
  AppUser call(AuthUserDto object) => AppUser(
        uid: object.uid.orEmptyString,
        displayName: object.displayName.orEmptyString,
        email: object.email.orEmptyString,
        photoUrl: object.photoUrl.orEmptyString,
      );
}
