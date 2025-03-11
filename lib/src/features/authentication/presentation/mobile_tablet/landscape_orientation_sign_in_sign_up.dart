import 'package:flutter/material.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/portrait_orientation_sign_in_sign_up.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

/// A Widget that displays the sign in sign up page in landscape orientation
/// for tablet devices.
class LandscapeOrientationSignInSignUpPage extends StatelessWidget {
  const LandscapeOrientationSignInSignUpPage({
    super.key,
    this.verificationType = VerificationType.login,
  });

  final VerificationType verificationType;

  @override
  Widget build(BuildContext context) {
    return PortraitOrientationSignInSignUp(
      verificationType: verificationType,
    );
  }
}
