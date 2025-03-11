import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/features/authentication/presentation/common_widgets/landscape_family_image.dart';
import 'package:piix_mobile/src/theme/piix_colors.dart';
import 'package:piix_mobile/src/utils/size_context.dart';

/// A container for the landscape orientation of the authentication page.
///
/// It contains a [Row] where the first child is a [LandscapeFamilyImage] and
/// the second child is the [child] widget.
class LandscapeOrientationAuthenticationContainer extends StatelessWidget {
  const LandscapeOrientationAuthenticationContainer({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: Sizes.p24.w,
        right: Sizes.p24.w,
        bottom: kToolbarHeight.h,
      ),
      height: context.screenHeight,
      width: context.screenWidth,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Flexible(
              flex: 5,
              child: LandscapeFamilyImage(),
            ),
            if (child != null)
              Flexible(
                flex: 7,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Sizes.p16.h,
                    horizontal: Sizes.p8.w,
                  ),
                  child: Card(
                    child: Container(
                      height: context.screenHeight,
                      decoration: BoxDecoration(
                        color: PiixColors.space,
                        borderRadius: BorderRadius.circular(Sizes.p16),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes.p16.w,
                        vertical: Sizes.p16.h,
                      ),
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
