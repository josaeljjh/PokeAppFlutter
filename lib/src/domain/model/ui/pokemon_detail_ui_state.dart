import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/pokemon/pokemon_detail.dart';

part 'pokemon_detail_ui_state.freezed.dart';

@freezed
abstract class PokemonDetailUiState with _$PokemonDetailUiState {
  const factory PokemonDetailUiState({
    @Default(true) bool isLoading,
    @Default(false) bool isError,
    PokemonDetail? detail,
    String? errorCode,
  }) = _PokemonDetailUiState;
}
