import 'package:firebase_auth/firebase_auth.dart';
import 'package:piix_mobile/src/features/authentication/data/auth_repository.dart';
import 'package:piix_mobile/src/features/authentication/domain/authentication_model_barrel_file.dart';
import 'package:piix_mobile/src/network/app_exception.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

/// Handles all related authentication calls to the AuthRepository
/// and to FirebaseAuth services
class AuthService {
  //The constructor for the AuthService
  AuthService(this._firebaseAuth, this._authRepository);

  ///The instance of [FirebaseAuth] to handle [Firebase] authentication
  final FirebaseAuth _firebaseAuth;

  ///The instance of [AuthRepository] to handle authentication
  ///related operations
  final AuthRepository _authRepository;

  ///Sends a verification code to the passed email
  Future<void> sendVerificationCodeByEmail(
    String email,
    String languageCode,
    VerificationType verificationType,
  ) {
    return _authRepository.sendVerificationCodeByEmail(
      email,
      languageCode,
      verificationType,
    );
  }

  ///Creates an account with email and verification code
  Future<void> createAccountWithEmailAndVerificationCode(
    String email,
    String verificationCode,
    String languageCode,
  ) async {
    //Obtain a custom token with email and verification code
    final customToken =
        await _authRepository.createAccountWithEmailAndVerificationCode(
      email,
      verificationCode,
      languageCode,
    );

    ///Sign in with the custom token
    await _customSignIn(customToken);
  }

  ///Sign in with email and verification code
  Future<void> signInWithEmailAndVerificationCode(
    String email,
    String verificationCode,
    String languageCode,
  ) async {
    //Obtain a custom token with email and verification code
    final customToken =
        await _authRepository.getCustomTokenWithEmailAndVerificationCode(
      email,
      verificationCode,
      languageCode,
    );

    ///Sign in with the custom token
    await _customSignIn(customToken);
  }

  ///Sign out the current user and revoke refresh tokens
  ///even if it cannot revoke the refresh tokens
  ///it will still sign out the user from [FirebaseAuth]
  Future<void> signOut() async {
    try {
      //Revoke refresh tokens
      await _authRepository.revokeRefreshTokens();
    } catch (e) {
      //TODO: log error
      //no - op
    } finally {
      //Sign out the user from [FirebaseAuth]
      await _firebaseAuth.signOut();
    }
  }

  ///Sign in with a custom token obtained from the [AuthRepository]
  ///into [FirebaseAuth]
  Future<void> _customSignIn(String customToken) async {
    try {
      //Sign in with the custom token
      await _firebaseAuth.signInWithCustomToken(customToken);
    } catch (e) {
      //TODO: log error
      throw CustomTokenFailedException();
    }
  }

  ///Called each time the authentication state changes
  ///and returns the current user by converting the [User] to [AppUser].
  Stream<AppUser?> authStateChange() =>
      _firebaseAuth.authStateChanges().map(_convertUser);

  ///Called each time the id token changes
  ///and returns the current user by converting the [User] to [AppUser].
  Stream<AppUser?> idTokenChanges() =>
      _firebaseAuth.idTokenChanges().map(_convertUser);

  ///Returns the current user by converting the [User] to [AppUser].
  AppUser? get currentUser => _convertUser(_firebaseAuth.currentUser);

  ///Converts the [User] to [AppUser]
  AppUser? _convertUser(User? user) =>
      user == null ? null : FirebaseAppUser(user);
}

///The provider for the [AuthService]
@Riverpod(keepAlive: true)
AuthService authService(AuthServiceRef ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthService(firebaseAuth, authRepository);
}

///The provider to watch the authentication state changes
@Riverpod(keepAlive: true)
Stream<AppUser?> authStateChanges(AuthStateChangesRef ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChange();
}

///The provider to watch the id token changes
@Riverpod(keepAlive: true)
Stream<AppUser?> idTokenChanges(IdTokenChangesRef ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.idTokenChanges();
}
