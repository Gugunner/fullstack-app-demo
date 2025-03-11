import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/landscape_orientation_welcome.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/portrait_orientation_welcome.dart';

/// A welcome page for tablet devices.
class TabletWelcomePage extends StatelessWidget {
  const TabletWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        // If the device is in landscape orientation, display the
        //landscape welcome page.
        if (orientation == Orientation.landscape) {
          return Container(
              padding: EdgeInsets.only(
                top: kToolbarHeight.h,
              ),
              child: const LandscapeOrientationWelcome());
        }
        // If the device is in portrait orientation, display the
        // portrait welcome page.
        return const PortraitOrientationWelcome();
      }),
    );
  }
}
