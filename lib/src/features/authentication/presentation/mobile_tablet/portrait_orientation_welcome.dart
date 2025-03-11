import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piix_mobile/src/common_widgets/common_widgets_barrel_file.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/constants/screen_breakpoints.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/welcome_actions.dart';
import 'package:piix_mobile/src/theme/theme_barrel_file.dart';
import 'package:piix_mobile/src/utils/app_assets.dart';
import 'package:piix_mobile/src/utils/size_context.dart';

/// A Widget that displays the welcome page in portrait orientation
/// for mobile and tablet devices.
class PortraitOrientationWelcome extends ConsumerWidget {
  const PortraitOrientationWelcome({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: context.screenHeight,
      width: context.screenWidth,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.familyImagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          SizedBox(
            height: context.screenHeight,
            width: context.screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: Sizes.p16,
                    top: Sizes.p64.h,
                    bottom: Sizes.p16,
                  ),
                  child: const AppLogo(),
                ),
                Expanded(child: gapH64),
                _BottomFadeFilteredZone(
                  child: WelcomeActions(
                    textColor: PiixColors.space,
                    textScaleFactor: context.screenWidth > ScreenBreakPoint.md
                        ? tabletTextScaleFactor
                        : mobileTextScaleFactor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// A Widget that displays a bottom fade filtered zone.
class _BottomFadeFilteredZone extends StatelessWidget {
  const _BottomFadeFilteredZone({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 3),
        child: Container(
          height: context.screenHeight * 0.4,
          width: context.screenWidth,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                PiixColors.space.withValues(alpha: 0.85),
                PiixColors.space.withValues(alpha: 0.75),
                PiixColors.space.withValues(alpha: 0.5),
                PiixColors.space.withValues(alpha: 0.0),
              ])),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p16,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
