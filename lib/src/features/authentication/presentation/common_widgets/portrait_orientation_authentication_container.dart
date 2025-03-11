import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/theme/piix_colors.dart';
import 'package:piix_mobile/src/utils/size_context.dart';

///A container with padding, background color and border radius for 
///portrait orientation.
///
///This container is used to wrap the [child] widget in a portrait layout.
class PortraitOrientationAuthenticationContainer extends StatelessWidget {
  const PortraitOrientationAuthenticationContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.p32.w,
        vertical: Sizes.p32.h,
      ),
      child: Container(
        height: context.screenHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.p16),
          color: PiixColors.space,
        ),
        padding: EdgeInsets.all(Sizes.p32.h),
        child: SingleChildScrollView(child: child),
      ),
    );
  }
}
