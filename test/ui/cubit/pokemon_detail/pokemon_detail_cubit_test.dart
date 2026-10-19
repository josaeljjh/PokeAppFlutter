import 'package:poke_app/src/core/resources/data_state.dart';
import 'package:poke_app/src/domain/model/data/pokemon/pokemon_detail.dart';
import 'package:poke_app/src/domain/model/ui/pokemon_detail_ui_state.dart';
import 'package:poke_app/src/domain/uses_cases/pokemon/get_pokemon_detail_use_case.dart';
import 'package:poke_app/src/ui/features/pokemon_detail/cubit/pokemon_detail_cubit.dart';

import '../../../helpers/test_helpers.dart';

class MockGetPokemonDetailUseCase extends Mock
    implements GetPokemonDetailUseCase {}

void main() {
  late MockGetPokemonDetailUseCase getDetail;
  const detail = PokemonDetail(id: 25, name: 'Pikachu', imageUrl: 'p.png');

  setUpAll(() => registerFallbackValue(const PokemonParams(id: 0)));

  setUp(() => getDetail = MockGetPokemonDetailUseCase());

  blocTest<PokemonDetailCubit, PokemonDetailUiState>(
    'loadDetail emite el detalle',
    build: () {
      when(() => getDetail.call(any()))
          .thenAnswer((_) async => const DataSuccess(data: detail));
      return PokemonDetailCubit(getPokemonDetailUseCase: getDetail);
    },
    act: (cubit) => cubit.loadDetail(25),
    expect: () => const [
      PokemonDetailUiState(),
      PokemonDetailUiState(isLoading: false, detail: detail),
    ],
  );

  blocTest<PokemonDetailCubit, PokemonDetailUiState>(
    'loadDetail emite error',
    build: () {
      when(() => getDetail.call(any()))
          .thenAnswer((_) async => const DataError(error: 'boom'));
      return PokemonDetailCubit(getPokemonDetailUseCase: getDetail);
    },
    act: (cubit) => cubit.loadDetail(25),
    expect: () => const [
      PokemonDetailUiState(),
      PokemonDetailUiState(isLoading: false, isError: true, errorCode: 'boom'),
    ],
  );
}
