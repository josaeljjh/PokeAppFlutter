import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../domain/model/ui/pokemon_detail_ui_state.dart';
import '../../../../domain/uses_cases/pokemon/get_pokemon_detail_use_case.dart';

class PokemonDetailCubit extends Cubit<PokemonDetailUiState> {
  PokemonDetailCubit({required this.getPokemonDetailUseCase})
      : super(const PokemonDetailUiState());

  final GetPokemonDetailUseCase getPokemonDetailUseCase;

  Future<void> loadDetail(int id) async {
    emit(const PokemonDetailUiState());
    final result = await getPokemonDetailUseCase.call(PokemonParams(id: id));
    if (result is DataSuccess) {
      emit(PokemonDetailUiState(isLoading: false, detail: result.data));
    } else {
      emit(PokemonDetailUiState(
        isLoading: false,
        isError: true,
        errorCode: result.error,
      ));
    }
  }
}
