import 'package:freezed_annotation/freezed_annotation.dart';

part 'named_resource_dto.freezed.dart';
part 'named_resource_dto.g.dart';

/// Recurso genérico de PokeAPI: `{ "name": "...", "url": "..." }`.
@freezed
abstract class NamedResourceDto with _$NamedResourceDto {
  const factory NamedResourceDto({
    @Default('') String? name,
    @Default('') String? url,
  }) = _NamedResourceDto;

  factory NamedResourceDto.fromJson(Map<String, dynamic> json) =>
      _$NamedResourceDtoFromJson(json);
}
