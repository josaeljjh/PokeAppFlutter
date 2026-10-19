import 'package:freezed_annotation/freezed_annotation.dart';

part 'region.freezed.dart';

@freezed
abstract class Region with _$Region {
  const factory Region({
    required int id,
    required String name,
    required String displayName,
  }) = _Region;
}
