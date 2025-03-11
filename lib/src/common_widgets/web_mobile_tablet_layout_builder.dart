import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piix_mobile/app_bootstrap.dart';
import 'package:piix_mobile/src/constants/screen_breakpoints.dart';

/// A layout builder Widget that displays the appropriate layout based on the
/// screen size and the platform where the app is currently running.
///
/// For example, if the app is running on a web platform, the [twoColumn] Widget
/// will be displayed if the screen width is greater than or equal to the extra
/// large screen breakpoint, otherwise the [oneColumn] Widget will be displayed.
///
/// If the app is running on a mobile or tablet platform, the [tablet] Widget
/// will be displayed if the screen width and height are greater than or equal
/// to the medium screen breakpoint, otherwise the [mobile] Widget will be
/// displayed.
class WebMobileTabletLayoutBuilder extends ConsumerWidget {
  const WebMobileTabletLayoutBuilder({
    super.key,
    this.twoColumn,
    this.oneColumn,
    this.tablet,
    this.mobile,
  });

  /// The Widget to display when the app is running on a web platform and the
  /// screen width is greater than or equal to the extra large screen
  /// breakpoint.
  final Widget? twoColumn;

  /// The Widget to display when the app is running on a web platform and the
  /// screen width is less than the extra large screen breakpoint.
  final Widget? oneColumn;

  /// The Widget to display when the app is running on a mobile or tablet
  /// platform and the screen width and height are greater than or equal to the
  /// medium screen breakpoint.
  final Widget? tablet;

  /// The Widget to display when the app is running on a mobile or tablet
  /// platform and the screen width and height are less than the medium screen
  /// breakpoint.
  final Widget? mobile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // * Check if the app is running on a mobile or tablet device
    final isWeb = ref.watch(isWebProvider);
    return LayoutBuilder(builder: (context, constraints) {
      // * Get the maximum width of the context
      final maxWidth = constraints.maxWidth;
      // * Get the maximum height of the context
      final maxHeight = constraints.maxHeight;
      // * Display the appropriate web welcome page based on the screen size
      if (isWeb) {
        if (twoColumn != null && maxWidth >= ScreenBreakPoint.xl) {
          return twoColumn!;
        } else {
          return oneColumn!;
        }
      }
      // * Display the appropriate mobile or tablet welcome page based on the
      // * screen size
      if (tablet != null &&
          ScreenBreakPoint.showLandsapeLayout(maxWidth, maxHeight)) {
        return tablet!;
      } else {
        return mobile!;
      }
    });
  }
}
