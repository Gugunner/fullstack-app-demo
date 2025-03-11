import 'package:piix_mobile/src/features/authentication/application/auth_service.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_verification_code_controller.g.dart';

///The controller used to request that a verification code be sent through 
///a channel.
@riverpod
class SendVerificationCodeController extends _$SendVerificationCodeController {
  //Initialize with a null state.
  @override
  FutureOr<void> build() {
    // nothing to do
  }

  Future<void> sendVerificationCodeByEmail(String email, String languageCode,
      VerificationType verificationType) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authServiceProvider).sendVerificationCodeByEmail(
            email,
            languageCode,
            verificationType,
          ),
    );
  }
}
