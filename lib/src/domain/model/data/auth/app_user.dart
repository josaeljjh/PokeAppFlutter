import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    @Default('') String displayName,
    @Default('') String email,
    @Default('') String photoUrl,
  }) = _AppUser;
}
