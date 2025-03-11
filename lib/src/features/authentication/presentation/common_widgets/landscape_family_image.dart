import 'package:flutter/material.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/utils/app_assets.dart';
import 'package:piix_mobile/src/utils/size_context.dart';

/// A landscape image of a family inside a [Container]
/// with border radius.
///
/// It fits the context width and height.
class LandscapeFamilyImage extends StatelessWidget {
  const LandscapeFamilyImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.screenHeight,
      width: context.screenWidth,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.familyImagePath),
          fit: BoxFit.fitWidth,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Sizes.p16),
          bottomLeft: Radius.circular(Sizes.p16),
        ),
      ),
    );
  }
}
