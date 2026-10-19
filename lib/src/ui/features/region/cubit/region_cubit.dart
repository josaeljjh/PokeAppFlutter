import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/base/use_case.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../domain/model/data/region/region.dart';
import '../../../../domain/model/ui/region_ui_state.dart';
import '../../../../domain/uses_cases/region/get_region_pokemon_use_case.dart';
import '../../../../domain/uses_cases/region/get_regions_use_case.dart';

class RegionCubit extends Cubit<RegionUiState> {
  RegionCubit({
    required this.getRegionsUseCase,
    required this.getRegionPokemonUseCase,
  }) : super(const RegionUiState());

  final GetRegionsUseCase getRegionsUseCase;
  final GetRegionPokemonUseCase getRegionPokemonUseCase;

  Future<void> loadRegions() async {
    emit(state.copyWith(isLoading: true, isError: false, errorCode: null));
    final result = await getRegionsUseCase.call(NoParams());
    if (result is DataSuccess) {
      emit(state.copyWith(isLoading: false, regions: result.data!));
    } else {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        errorCode: result.error,
      ));
    }
  }

  Future<void> selectRegion(Region region) async {
    if (state.loadingRegionId != null) return;
    emit(state.copyWith(loadingRegionId: region.id, errorCode: null));
    final result =
        await getRegionPokemonUseCase.call(RegionParams(regionId: region.id));
    if (result is DataSuccess) {
      emit(state.copyWith(
        loadingRegionId: null,
        selectedPokedex: result.data,
      ));
    } else {
      emit(state.copyWith(loadingRegionId: null, errorCode: result.error));
    }
  }

  /// Consume los eventos de una sola vez (navegación / snackbar).
  void clearEvents() =>
      emit(state.copyWith(selectedPokedex: null, errorCode: null));
}
