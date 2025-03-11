import 'package:flutter/material.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/constants/screen_breakpoints.dart';
import 'package:piix_mobile/src/features/authentication/presentation/web/welcome_to_piix_one_time_code_submit.dart';
import 'package:piix_mobile/src/theme/theme_barrel_file.dart';
import 'package:piix_mobile/src/utils/size_context.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

///A general layout of the email submit form for the [SignInPage]
/// and [SignUpPage].
class OneColumnSignInSignUpSubmit extends StatelessWidget {
  const OneColumnSignInSignUpSubmit({
    super.key,
    this.verificationType = VerificationType.login,
  });

  final VerificationType verificationType;

  @override
  Widget build(BuildContext context) {
    // * Get the maximum width of the screen
    final maxWidth = MediaQuery.of(context).size.width;
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
    return Container(
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
          child: WelcomeToPiixOneTimeCodeSubmit(
            parentPadding: padding,
            width: width,
            verificationType: verificationType,
          ),
        ),
      ),
    );
  }
}
