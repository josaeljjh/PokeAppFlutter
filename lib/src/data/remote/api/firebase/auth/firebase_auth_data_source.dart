import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../core/resources/data_state.dart';
import '../../../dto/auth/auth_user_dto.dart';
import '../../remote/auth/auth_data_source.dart';

const signInCancelledError = 'sign_in_cancelled';
const firebaseNotConfiguredError = 'firebase_not_configured';

/// Login con Google + Firebase (migrado de `LoginFragment`/`ViewModelLogin`).
///
/// [authProvider] se resuelve de forma perezosa para que la app no falle
/// si Firebase no pudo inicializarse (p. ej. iOS sin GoogleService-Info.plist).
class FirebaseAuthDataSourceImpl implements AuthDataSource {
  FirebaseAuthDataSourceImpl({
    required this.authProvider,
    required this.googleSignIn,
  });

  final FirebaseAuth? Function() authProvider;
  final GoogleSignIn googleSignIn;

  @override
  Future<AuthUserDto?> currentUser() async {
    final user = authProvider()?.currentUser;
    return user == null ? null : _toDto(user);
  }

  @override
  Future<DataState<AuthUserDto>> signInWithGoogle() async {
    final auth = authProvider();
    if (auth == null) {
      return const DataError(error: firebaseNotConfiguredError);
    }
    try {
      final account = await googleSignIn.signIn();
      if (account == null) {
        return const DataError(error: signInCancelledError);
      }
      final googleAuth = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      final result = await auth.signInWithCredential(credential);
      final user = result.user;
      if (user == null) {
        return const DataError(error: 'Firebase user is null');
      }
      return DataSuccess(data: _toDto(user));
    } on FirebaseAuthException catch (e) {
      return DataError(error: e.message ?? e.code);
    } catch (e) {
      return DataError(error: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await authProvider()?.signOut();
    try {
      await googleSignIn.signOut();
    } catch (_) {
      // Sin sesión de Google activa: nada que cerrar.
    }
  }

  AuthUserDto _toDto(User user) => AuthUserDto(
        uid: user.uid,
        displayName: user.displayName,
        email: user.email,
        photoUrl: user.photoURL,
      );
}
