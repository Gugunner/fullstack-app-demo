import 'package:piix_mobile/src/features/authentication/domain/authentication_model_barrel_file.dart';

class FakeAccountUser extends AccountUser {
  FakeAccountUser({
    required super.uid,
    required super.email,
    required super.emailVerified,
    required super.name,
    required super.firstLastName,
    required super.gender,
    required super.dateOfBirth,
    required super.documentation,
    super.invitationCode,
    super.verificationStatus = VerificationStatus.IDLE,
  });
}
