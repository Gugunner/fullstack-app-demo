import 'package:flutter/material.dart';
import 'package:piix_mobile/src/features/authentication/presentation/common_widgets/landscape_orientation_authentication_container.dart';
import 'package:piix_mobile/src/features/authentication/presentation/common_widgets/portrait_orientation_authentication_container.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/portrait_email_verification_code.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

/// A email verification code page for tablet devices.
class TabletEmailVerificationCodePage extends StatelessWidget {
  const TabletEmailVerificationCodePage({
    super.key,
    required this.email,
    this.verificationType = VerificationType.login,
  });

  final String email;
  final VerificationType verificationType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return PortraitOrientationAuthenticationContainer(
            child: PortraitOrientationEmailVerificationCode(
              email: email,
              verificationType: verificationType,
            ),
          );
        }
        return LandscapeOrientationAuthenticationContainer(
          child: PortraitOrientationEmailVerificationCode(
            email: email,
            verificationType: verificationType,
          ),
        );
      }),
    );
  }
}
