import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/tools/const.dart';
import '../../../../domain/model/data/pokemon/pokemon.dart';
import '../../../../domain/model/data/team/team.dart';
import '../../../../domain/model/ui/select_ui_state.dart';
import '../../../../domain/uses_cases/team/save_team_use_case.dart';

const maxTeamReachedError = 'max_team_reached';

class SelectCubit extends Cubit<SelectUiState> {
  SelectCubit({
    required RegionPokedex pokedex,
    required this.saveTeamUseCase,
    DateTime Function()? clock,
  })  : _clock = clock ?? DateTime.now,
        super(SelectUiState(pokedex: pokedex));

  final SaveTeamUseCase saveTeamUseCase;
  final DateTime Function() _clock;

  bool get canSave =>
      state.selectedIds.length >= minTeamSize &&
      state.selectedIds.length <= maxTeamSize;

  bool isSelected(Pokemon pokemon) => state.selectedIds.contains(pokemon.id);

  void toggle(Pokemon pokemon) {
    final ids = [...state.selectedIds];
    if (ids.contains(pokemon.id)) {
      ids.remove(pokemon.id);
    } else {
      if (ids.length >= maxTeamSize) {
        emit(state.copyWith(errorCode: maxTeamReachedError));
        return;
      }
      ids.add(pokemon.id);
    }
    emit(state.copyWith(selectedIds: ids, errorCode: null));
  }

  void search(String query) => emit(state.copyWith(query: query));

  Future<void> saveTeam(String name) async {
    emit(state.copyWith(isSaving: true, errorCode: null));
    final result = await saveTeamUseCase.call(
      Team(
        name: name,
        region: state.pokedex.region.displayName,
        pokemon: state.selectedPokemon,
        createdAt: _clock(),
      ),
    );
    if (result is DataSuccess) {
      emit(state.copyWith(isSaving: false, savedTeam: result.data));
    } else {
      emit(state.copyWith(isSaving: false, errorCode: result.error));
    }
  }

  void clearError() => emit(state.copyWith(errorCode: null));
}
