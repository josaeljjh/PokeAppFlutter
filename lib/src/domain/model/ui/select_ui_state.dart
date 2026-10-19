import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/pokemon/pokemon.dart';
import '../data/team/team.dart';

part 'select_ui_state.freezed.dart';

@freezed
abstract class SelectUiState with _$SelectUiState {
  const factory SelectUiState({
    required RegionPokedex pokedex,
    @Default([]) List<int> selectedIds,
    @Default('') String query,
    @Default(false) bool isSaving,
    Team? savedTeam,
    String? errorCode,
  }) = _SelectUiState;

  const SelectUiState._();

  List<Pokemon> get visiblePokemon {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return pokedex.pokemon;
    return pokedex.pokemon
        .where((p) => p.name.contains(q) || '${p.entryNumber}' == q)
        .toList();
  }

  List<Pokemon> get selectedPokemon => [
        for (final id in selectedIds)
          ...pokedex.pokemon.where((p) => p.id == id).take(1),
      ];
}
