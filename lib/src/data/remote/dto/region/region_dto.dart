import 'package:freezed_annotation/freezed_annotation.dart';

import 'named_resource_dto.dart';

part 'region_dto.freezed.dart';
part 'region_dto.g.dart';

/// `GET region/`
@freezed
abstract class RegionListDto with _$RegionListDto {
  const factory RegionListDto({
    @Default(0) int? count,
    @Default([]) List<NamedResourceDto>? results,
  }) = _RegionListDto;

  factory RegionListDto.fromJson(Map<String, dynamic> json) =>
      _$RegionListDtoFromJson(json);
}

/// `GET region/{id}/`
@freezed
abstract class RegionDto with _$RegionDto {
  const factory RegionDto({
    @Default(0) int? id,
    @Default('') String? name,
    @Default([]) List<NamedResourceDto>? pokedexes,
  }) = _RegionDto;

  factory RegionDto.fromJson(Map<String, dynamic> json) =>
      _$RegionDtoFromJson(json);
}
