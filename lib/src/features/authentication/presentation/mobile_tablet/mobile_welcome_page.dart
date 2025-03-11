import 'package:flutter/material.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/portrait_orientation_welcome.dart';

/// A welcome page for mobile devices.
class MobileWelcomePage extends StatelessWidget {
  const MobileWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PortraitOrientationWelcome();
  }
}
