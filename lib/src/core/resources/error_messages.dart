import 'package:localization/localization.dart';

import '../../data/remote/api/firebase/auth/firebase_auth_data_source.dart';
import '../../data/remote/api/poke_api/pokemon/poke_api_pokemon_data_source.dart';
import '../../domain/uses_cases/region/get_region_pokemon_use_case.dart';
import '../../domain/uses_cases/team/save_team_use_case.dart';
import '../../ui/features/select/cubit/select_cubit.dart';
import 'translations_constant.dart';

/// Traduce los códigos de error de data/domain a textos de UI.
String errorMessage(String? code, {String fallback = ERROR_GENERIC}) {
  switch (code) {
    case noInternetError:
      return ERROR_NO_INTERNET.i18n();
    case regionWithoutPokedexError:
      return ERROR_REGION_WITHOUT_POKEDEX.i18n();
    case signInCancelledError:
      return ERROR_SIGN_IN_CANCELLED.i18n();
    case firebaseNotConfiguredError:
      return ERROR_FIREBASE_NOT_CONFIGURED.i18n();
    case invalidTeamSizeError:
      return ERROR_INVALID_TEAM_SIZE.i18n();
    case maxTeamReachedError:
      return SELECT_MAX_REACHED.i18n();
    case emptyTeamNameError:
      return ERROR_EMPTY_TEAM_NAME.i18n();
    default:
      return fallback.i18n();
  }
}
