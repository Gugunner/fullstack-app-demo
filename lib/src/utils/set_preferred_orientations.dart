import 'package:flutter/services.dart';
import 'package:piix_mobile/src/constants/screen_breakpoints.dart';

///Sets the preferred orientations for the app based on the device width and
///height.
///
///Only devices with a width and height greater than or equal to the medium
///screen breakpoint will have landscape orientations.
Future<void> setPreferredOrientations(
    double deviceWidth, double deviceHeight) async {
  SystemChrome.setPreferredOrientations([
    //Checks if the device width and height are greater than or equal to the
    //medium screen breakpoint.
    if (deviceHeight >= ScreenBreakPoint.md &&
        deviceWidth >= ScreenBreakPoint.md) ...[
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
}
