// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:piix_mobile/src/features/authentication/domain/app_user_model.dart';

/// Fake user model for testing purposes.
class FakeAppUser extends AppUser {
  const FakeAppUser({
    required super.uid,
    required super.email,
    required super.emailVerified,
    required this.verificationCode,
  });

  /// Verification code for the user.
  final String verificationCode;

  FakeAppUser copyWith({
    String? uid,
    String? email,
    bool? emailVerified,
    String? verificationCode,
  }) {
    return FakeAppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }
}
