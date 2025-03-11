import 'package:flutter/material.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/constants/screen_breakpoints.dart';

/// A mixin to provide text scale factor based on the screen width.
/// 
/// This mixin provides a method [textScalerFromWidth] which returns a 
/// [TextScaler].
mixin TextScaleFactor {
  /// Returns a [TextScaler] based on the screen width.
  /// If [isWeb] is true, it will return a [TextScaler] based on the web text.
  /// Otherwise, it will return a [TextScaler] based on the screen width.
  TextScaler textScalerFromWidth(
    double width, {
    bool isWeb = false,
  }) {
    var textScaleFactor = webTextScaleFactor;
    if (!isWeb) {
      textScaleFactor = width > ScreenBreakPoint.md
          ? tabletTextScaleFactor
          : mobileTextScaleFactor;
    }
    return TextScaler.linear(textScaleFactor);
  }
}
