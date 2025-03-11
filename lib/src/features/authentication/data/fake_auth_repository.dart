import 'package:piix_mobile/src/features/authentication/data/auth_repository.dart';
import 'package:piix_mobile/src/utils/delay.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.addDelay = true});

  final bool addDelay;
  @override
  Future<CustomToken> createAccountWithEmailAndVerificationCode(
    String email,
    String verificationCode,
    String languageCode,
  ) async {
    await delay(addDelay);
    return 'fake_token';
  }

  @override
  Future<CustomToken> getCustomTokenWithEmailAndVerificationCode(
    String email,
    String verificationCode,
    String languageCode,
  ) async {
    await delay(addDelay);
    return 'fake_token';
  }

  @override
  Future<void> revokeRefreshTokens() async {
    await delay(addDelay);
  }

  @override
  Future<void> sendVerificationCodeByEmail(
    String email,
    String languageCode,
    VerificationType verificationType,
  ) async {
    await delay(addDelay);
  }
}
