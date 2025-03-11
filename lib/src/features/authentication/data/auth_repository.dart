import 'package:firebase_auth/firebase_auth.dart';
import 'package:piix_mobile/src/network/app_dio.dart';
import 'package:piix_mobile/src/network/app_exception.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

typedef CustomToken = String;

///The repository for authentication related operations
class AuthRepository {
  ///Constructor
  const AuthRepository(this._appDio);

  ///The instance of [AppDio] to make network requests
  final AppDio _appDio;

  ///Send verification code to passed email in the language provided
  ///either to a register or login verification type.
  Future<dynamic> sendVerificationCodeByEmail(
    String email,
    String languageCode,
    VerificationType verificationType,
  ) async {
    return _appDio.post('/sendVerificationCodeRequest', data: {
      'email': email,
      'languageCode': languageCode,
      'verificationType': verificationType.name,
    });
  }

  ///Create account with email and verification code and obtain custom token
  Future<CustomToken> createAccountWithEmailAndVerificationCode(
    String email,
    String verificationCode,
    String languageCode,
  ) async {
    final response = await _appDio
        .post('/createAccountAndCustomTokenWithEmailRequest', data: {
      'email': email,
      'code': verificationCode,
      'languageCode': languageCode,
    });
    if (response.data?['customToken'] == null) {
      throw CustomTokenFailedException();
    }
    return response.data?['customToken'];
  }

  ///Obtain a custom token with email and verification code
  Future<CustomToken> getCustomTokenWithEmailAndVerificationCode(
    String email,
    String verificationCode,
    String languageCode,
  ) async {
    final response =
        await _appDio.post('/getCustomTokenForCustomSignInRequest', data: {
      'email': email,
      'code': verificationCode,
      'languageCode': languageCode,
    });
    if (response.data?['customToken'] == null) {
      throw CustomTokenFailedException();
    }
    return response.data?['customToken'];
  }

  ///Revoke refresh tokens
  Future<dynamic> revokeRefreshTokens() async {
    return _appDio.put('/revokeRefreshTokensRequest');
  }
}

///The provider for the [AuthRepository]
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final appDio = ref.watch(appDioProvider);
  return AuthRepository(appDio);
}

///The provider for the [FirebaseAuth]
@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}
