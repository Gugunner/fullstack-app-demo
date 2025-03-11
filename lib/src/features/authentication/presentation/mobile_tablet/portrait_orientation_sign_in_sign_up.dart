import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piix_mobile/src/common_widgets/common_widgets_barrel_file.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/features/authentication/presentation/web/or_sign_in_sign_up_label.dart';
import 'package:piix_mobile/src/features/authentication/presentation/common_widgets/submit_email_input_for_verification_code_form.dart';
import 'package:piix_mobile/src/localization/app_intl.dart';
import 'package:piix_mobile/src/theme/piix_colors.dart';
import 'package:piix_mobile/src/theme/theme_context.dart';
import 'package:piix_mobile/src/utils/app_assets.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

/// A Widget that displays the sign in sign up page in portrait orientation
/// for mobile and tablet devices.
class PortraitOrientationSignInSignUp extends StatelessWidget {
  const PortraitOrientationSignInSignUp({
    super.key,
    this.verificationType = VerificationType.login,
  });

  final VerificationType verificationType;

  @override
  Widget build(BuildContext context) {
    final isLogin = verificationType.isLogin;
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppBar(
            backgroundColor: PiixColors.space,
            actions: [
              SvgPicture.asset(
                AppAssets.appLogoPath,
                color: PiixColors.primary,
                width: 46.w,
                height: 26.w,
              ),
            ],
          ),
          gapH24,
          SizedBox(
            child: TextScaled(
              text: isLogin
                  ? context.appIntl.login
                  : context.appIntl.createAccount,
              style: context.theme.textTheme.displaySmall,
            ),
          ),
          gapH20,
          SizedBox(
            child: TextScaled(
              text: isLogin
                  ? context.appIntl.enterTheEmailYouUsed
                  : context.appIntl.verifyYourEmailByEntering,
              style: context.theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          gapH32,
          SubmitEmailInputForVerificationCodeForm(
            verificationType: verificationType,
          ),
          gapH32,
          OrSignInSigUpLabel(verificationType: verificationType),
        ],
      ),
    );
  }
}
