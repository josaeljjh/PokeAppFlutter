import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/pokemon/pokemon.dart';
import '../data/region/region.dart';

part 'region_ui_state.freezed.dart';

@freezed
abstract class RegionUiState with _$RegionUiState {
  const factory RegionUiState({
    @Default(false) bool isLoading,
    @Default(false) bool isError,
    @Default([]) List<Region> regions,
    int? loadingRegionId,
    RegionPokedex? selectedPokedex,
    String? errorCode,
  }) = _RegionUiState;
}
