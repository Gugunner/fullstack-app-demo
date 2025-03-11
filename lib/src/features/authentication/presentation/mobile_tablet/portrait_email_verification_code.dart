import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piix_mobile/src/common_widgets/common_widgets_barrel_file.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/features/authentication/presentation/common_widgets/submit_verification_code_input_form.dart';
import 'package:piix_mobile/src/localization/app_intl.dart';
import 'package:piix_mobile/src/theme/piix_colors.dart';
import 'package:piix_mobile/src/theme/theme_context.dart';
import 'package:piix_mobile/src/utils/app_assets.dart';
import 'package:piix_mobile/src/utils/size_context.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';


/// A Widget that displays the email verification code page in portrait 
/// orientation for mobile and tablet devices.
class PortraitOrientationEmailVerificationCode extends ConsumerWidget {
  const PortraitOrientationEmailVerificationCode({
    super.key,
    required this.email,
    this.verificationType = VerificationType.login,
  });

  final String email;
  final VerificationType verificationType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendToEmailText = context.appIntl.enterTheCodeSentTo(email);
    return TextScaledWrapper(
      child: SizedBox(
        child: Column(
          children: [
            AppBar(
              leading: const SizedBox(),
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
            gapH16,
            Text(
              context.appIntl.enterTheVerificationCode,
              style: context.theme.textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            gapH12,
            Text.rich(
              TextSpan(
                text: sendToEmailText.split(email).first,
                children: [
                  TextSpan(
                    text: sendToEmailText.split(' ').last,
                    style: context.theme.textTheme.headlineMedium?.copyWith(
                      color: PiixColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              style: context.theme.textTheme.headlineMedium?.copyWith(
                color: PiixColors.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            gapH16,
            SubmitVerificationCodeInputForm(
              email: email,
              width: context.screenWidth,
              verificationType: verificationType,
            ),
            gapH64,
            const CopyRightText(),
          ],
        ),
      ),
    );
  }
}
