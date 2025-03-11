import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/portrait_email_verification_code.dart';
import 'package:piix_mobile/src/theme/piix_colors.dart';
import 'package:piix_mobile/src/utils/size_context.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

///A page that displays the email verification code input for mobile devices.
class MobileEmailVerificationCodePage extends StatelessWidget {
  const MobileEmailVerificationCodePage({
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
      body: Container(
        height: context.screenHeight,
        color: PiixColors.space,
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.p16.w,
        ),
        child: SingleChildScrollView(
          child: PortraitOrientationEmailVerificationCode(
            email: email,
            verificationType: verificationType,
          ),
        ),
      ),
    );
  }
}
