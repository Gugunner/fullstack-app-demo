import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/portrait_orientation_sign_in_sign_up.dart';
import 'package:piix_mobile/src/theme/piix_colors.dart';
import 'package:piix_mobile/src/utils/size_context.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

/// A sign in sign up page for mobile devices.
class MobileSignInSignUpPage extends StatelessWidget {
  const MobileSignInSignUpPage({
    super.key,
    this.verificationType = VerificationType.login,
  });

  final VerificationType verificationType;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PiixColors.space,
      height: context.screenHeight,
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.p16.w,
      ),
      child: SingleChildScrollView(
        child: PortraitOrientationSignInSignUp(
          verificationType: verificationType,
        ),
      ),
    );
  }
}
