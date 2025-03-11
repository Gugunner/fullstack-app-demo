import 'package:flutter/material.dart';
import 'package:piix_mobile/src/common_widgets/common_widgets_barrel_file.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/constants/screen_breakpoints.dart';
import 'package:piix_mobile/src/features/authentication/presentation/common_widgets/submit_verification_code_input_form.dart';
import 'package:piix_mobile/src/localization/app_intl.dart';
import 'package:piix_mobile/src/theme/piix_colors.dart';
import 'package:piix_mobile/src/theme/theme_context.dart';
import 'package:piix_mobile/src/utils/size_context.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

///A general layout of the verification submit page for the
///[EmailVerificationCodePage].
class OneColumnEmailVerificationCodePage extends StatelessWidget {
  const OneColumnEmailVerificationCodePage({
    super.key,
    required this.email,
    this.verificationType = VerificationType.login,
  });

  final String email;

  final VerificationType verificationType;

  @override
  Widget build(BuildContext context) {
    final sendToEmailText = context.appIntl.enterTheCodeSentTo(email);
    // * Get the maximum width of the screen
    final maxWidth = context.screenWidth;
    // * Get the padding based on the screen size
    final padding = maxWidth >= ScreenBreakPoint.lg
        ? Sizes.p32
        : maxWidth >= ScreenBreakPoint.md
            ? Sizes.p16
            : Sizes.p8;
    // * Get the width of the container based on the screen size
    final width = maxWidth >= ScreenBreakPoint.xl
        ? context.screenWidth
        : maxWidth >= ScreenBreakPoint.lg
            ? context.screenWidth * 0.5
            : maxWidth >= ScreenBreakPoint.md
                ? context.screenWidth * 0.6
                : context.screenWidth * 0.75;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: context.screenHeight,
        width: context.screenWidth,
        padding: EdgeInsets.all(padding),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.p16),
            color: PiixColors.space,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: maxWidth >= ScreenBreakPoint.xl
                  ? context.screenWidth * 0.25
                  : Sizes.p16,
            ),
            child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    gapH64,
                    const AppLogo(),
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
                            style: context.theme.textTheme.headlineMedium
                                ?.copyWith(
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
                    SizedBox(
                      width: width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SubmitVerificationCodeInputForm(
                            email: email,
                            width: width,
                            verificationType: verificationType,
                          ),
                        ],
                      ),
                    ),
                    gapH64,
                    const CopyRightText(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
