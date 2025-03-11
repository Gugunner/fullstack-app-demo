import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piix_mobile/src/utils/app_assets.dart';

/// A class that displays the app logo as an [SvgPicture].
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppAssets.appLogoPath,
      color: Theme.of(context).primaryColor,
      width: 288.h,
      height: 80.h,
    );
  }
}
