import 'package:flutter/material.dart';
import 'package:piix_mobile/src/common_widgets/common_widgets_barrel_file.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/features/authentication/presentation/common_widgets/landscape_orientation_authentication_container.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/welcome_actions.dart';

/// A Widget that displays the welcome page in landscape orientation
/// for tablet devices.
class LandscapeOrientationWelcome extends StatelessWidget {
  const LandscapeOrientationWelcome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LandscapeOrientationAuthenticationContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const AppLogo(),
          gapH16,
          const WelcomeActions(
            textScaleFactor: tabletTextScaleFactor,
          ),
        ],
      ),
    );
  }
}
