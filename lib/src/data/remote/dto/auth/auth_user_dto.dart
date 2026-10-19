import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user_dto.freezed.dart';

@freezed
abstract class AuthUserDto with _$AuthUserDto {
  const factory AuthUserDto({
    @Default('') String? uid,
    @Default('') String? displayName,
    @Default('') String? email,
    @Default('') String? photoUrl,
  }) = _AuthUserDto;
}
