import 'package:piix_mobile/src/features/authentication/application/auth_service_barrel_file.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_account_sign_in_page_controller.g.dart';

///The controller used to create an account or sign in with email
///and verification code.
@riverpod
class CreateAccountSignInController extends _$CreateAccountSignInController {
  //Initialize with a null state.
  @override
  FutureOr<void> build() {
    // nothing to do
  }

  Future<void> authenticateWithEmailAndVerificationCode(
    VerificationType verificationType, {
    required String email,
    required String verificationCode,
    required String languageCode,
  }) async {
    state = const AsyncLoading();
    switch (verificationType) {
      case VerificationType.register:
        state = await AsyncValue.guard(
          () => ref
              .read(authServiceProvider)
              .createAccountWithEmailAndVerificationCode(
                  email, verificationCode, languageCode),
        );
        break;
      case VerificationType.login:
        state = await AsyncValue.guard(
          () => ref
              .read(authServiceProvider)
              .signInWithEmailAndVerificationCode(
                  email, verificationCode, languageCode),
        );
        break;
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state =
        await AsyncValue.guard(() => ref.read(authServiceProvider).signOut());
  }
}
