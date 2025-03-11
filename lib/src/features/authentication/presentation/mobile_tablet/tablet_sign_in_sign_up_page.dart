import 'package:flutter/material.dart';
import 'package:piix_mobile/src/features/authentication/presentation/common_widgets/landscape_orientation_authentication_container.dart';
import 'package:piix_mobile/src/features/authentication/presentation/common_widgets/portrait_orientation_authentication_container.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/landscape_orientation_sign_in_sign_up.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/portrait_orientation_sign_in_sign_up.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

/// A sign in sign up page for tablet devices.
class TabletSignInSignUpPage extends StatelessWidget {
  const TabletSignInSignUpPage({
    super.key,
    this.verificationType = VerificationType.login,
  });

  final VerificationType verificationType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return PortraitOrientationAuthenticationContainer(
            child: PortraitOrientationSignInSignUp(
              verificationType: verificationType,
            ),
          );
        }
        return LandscapeOrientationAuthenticationContainer(
          child: LandscapeOrientationSignInSignUpPage(
            verificationType: verificationType,
          ),
        );
      }),
    );
  }
}
