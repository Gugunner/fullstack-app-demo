import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piix_mobile/src/common_widgets/common_widgets_barrel_file.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/localization/app_intl.dart';
import 'package:piix_mobile/src/routing/app_router.dart';
import 'package:piix_mobile/src/theme/theme_barrel_file.dart';

///A general checkbox that is used by the user to accept the app
///"Term conditions" and "Privacy Policy".
///
///Pass [onChanged] as a [void] function that controls [check] from
///the parent [Widget].
class TermsAndPrivacyCheck extends ConsumerStatefulWidget {
  const TermsAndPrivacyCheck({
    super.key,
    this.check = false,
    required this.onChanged,
  });

  ///Signals the [Checkbox] to either be filled or not.
  final bool check;

  ///Controls [check].
  final void Function(bool?)? onChanged;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __TermsAndPrivacyCheckState();
}

class __TermsAndPrivacyCheckState extends ConsumerState<TermsAndPrivacyCheck> {
  final _termsGesture = TapGestureRecognizer();
  final _privacyGesture = TapGestureRecognizer();

  void _navigateToTermsOfServicePage() =>
      ref.read(goRouterProvider).goNamed(AppRoute.termsOfService.name);

  void _navigateToPrivacyPolicyPage() =>
      ref.read(goRouterProvider).goNamed(AppRoute.privacyPolicy.name);

  @override
  void initState() {
    super.initState();
    // * Initialize the tap gesture recognizer
    // * Navigate to the terms of service page when the user taps on the "Terms of Service" text \\
    _termsGesture.onTap = _navigateToTermsOfServicePage;
    // * Navigate to the privacy policy page when the user taps on the "Privacy Policy" text \\
    _privacyGesture.onTap = _navigateToPrivacyPolicyPage;
  }

  @override
  Widget build(BuildContext context) {
    final appIntl = context.appIntl;
    //* Splits the text in two halves where "Terms of Service" works as the splitter. //
    final splitReadAndAcceptTermsAndPrivacy =
        appIntl.readAndAcceptTermsAndPrivacy.split(
      appIntl.termsOfService,
    );
    final readAndAcceptText = splitReadAndAcceptTermsAndPrivacy[0];
    //* Gets the "and" connector found after splitting the second halve in two havles where "Privacy Policy" works as the splitter//
    final connectorText =
        splitReadAndAcceptTermsAndPrivacy[1].split(appIntl.privacyPolicy)[0];
    //*Gets the last pint "." found after splitting the text in two halves where "Privacy Policy" works as the splitter. //
    final endMark =
        appIntl.readAndAcceptTermsAndPrivacy.split(appIntl.privacyPolicy)[1];
    return SizedBox(
      child: Row(
        children: [
          Checkbox(
            value: widget.check,
            onChanged: widget.onChanged,
          ),
          gapW4,
          Expanded(
            child: TextScaled(
              textSpan: TextSpan(
                text: readAndAcceptText,
                children: [
                  TextSpan(
                    text: appIntl.termsOfService,
                    style: const TextStyle(
                      color: PiixColors.active,
                    ),
                    recognizer: _termsGesture,
                  ),
                  TextSpan(
                    text: connectorText,
                  ),
                  TextSpan(
                    text: appIntl.privacyPolicy,
                    style: const TextStyle(
                      color: PiixColors.active,
                    ),
                    recognizer: _privacyGesture,
                  ),
                  TextSpan(
                    text: endMark,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
