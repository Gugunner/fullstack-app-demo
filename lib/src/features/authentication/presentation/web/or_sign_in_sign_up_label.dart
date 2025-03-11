import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piix_mobile/src/common_widgets/common_widgets_barrel_file.dart';
import 'package:piix_mobile/src/constants/widget_keys.dart';
import 'package:piix_mobile/src/localization/app_intl.dart';
import 'package:piix_mobile/src/routing/app_router.dart';
import 'package:piix_mobile/src/theme/theme_barrel_file.dart';
import 'package:piix_mobile/src/theme/theme_context.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';
import 'package:flutter_gen/gen_l10n/app_intl.dart';

/// A label that allows the user to navigate to the sign up page or
/// navigate to the sign in page.
///
/// This widget is used in the web version of the app.
class OrSignInSigUpLabel extends ConsumerStatefulWidget {
  const OrSignInSigUpLabel({
    super.key,
    this.verificationType = VerificationType.login,
  });

  ///Controls the navigation to the sign up page or the sign in page.
  final VerificationType verificationType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __OrSignInSigUpLabelState();
}

class __OrSignInSigUpLabelState extends ConsumerState<OrSignInSigUpLabel> {
  final tapGesture = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    // * Intialize the tap gesture recognizer
    // * Navigate to the sign up page when the user taps on the "Sign up" text
    tapGesture.onTap = () {
      final appRouteName = widget.verificationType.isLogin
          ? AppRoute.signUp.name
          : AppRoute.signIn.name;
      ref.read(goRouterProvider).goNamed(appRouteName);
    };
  }

  AppIntl get appIntl => context.appIntl;

  @override
  Widget build(BuildContext context) {
    final isLogin = widget.verificationType.isLogin;
    return TextScaled(
      key: WidgetKeys.switchSignInSignUpButton,
      textSpan: TextSpan(
        text:
            '''${isLogin ? appIntl.dontHaveAnAccount : appIntl.alreadyHaveAnAccount} ''',
        style: context.theme.textTheme.labelLarge?.copyWith(
          color: PiixColors.secondary,
        ),
        children: [
          TextSpan(
            text: '${isLogin ? appIntl.signUp : appIntl.signIn}',
            style: context.theme.textTheme.labelLarge?.copyWith(
              color: PiixColors.primary,
            ),
            recognizer: tapGesture,
          ),
        ],
      ),
    );
  }
}
