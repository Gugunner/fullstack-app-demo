import 'package:flutter_test/flutter_test.dart';
import 'package:piix_mobile/src/features/authentication/presentation/authentication_page_barrel_file.dart';

import '../../../robot.dart';
import '../../golden_variant.dart';

void main() {
  testWidgets(
    'Golden Sign In Page Tablet',
    (tester) async {
      //* This is the robot that will help us interact with the widgets
      final robot = Robot(tester);
      //* Get the current variant
      final currentVariant = tabletVariants.currentValue!;
      //* Get the current size from the current variant
      final currentSize = currentVariant.size;
      //* Setup the golden test surface size and load all the necessary fonts
      await robot.golden.setSurfaceSize(currentSize);
      await robot.golden.loadAllFonts();
      //* Pump the app with fakes
      await robot.pumpWidget(
        const SignInPage(),
        isWeb: false,
      );
      //* Precache all the images and svgs
      await robot.golden.precacheSvgs();
      await robot.golden.precacheImages();
      await robot.golden.precacheDecorationImages();
      await expectLater(
        find.byType(SignInPage),
        matchesGoldenFile(
          currentVariant.getGoldenFileName('sign_in_page'),
        ),
      );
    },
    variant: tabletVariants,
    tags: ['golden', 'layout', 'tablet', 'ios'],
    skip: false,
  );

  testWidgets(
    'Golden Sign Up Page Tablet',
    (tester) async {
      //* This is the robot that will help us interact with the widgets
      final robot = Robot(tester);
      //* Get the current variant
      final currentVariant = tabletVariants.currentValue!;
      //* Get the current size from the current variant
      final currentSize = currentVariant.size;
      //* Setup the golden test surface size and load all the necessary fonts
      await robot.golden.setSurfaceSize(currentSize);
      await robot.golden.loadAllFonts();
      //* Pump the app with fakes
      await robot.pumpWidget(
        const SignUpPage(),
        isWeb: false,
      );
      //* Precache all the images and svgs
      await robot.golden.precacheSvgs();
      await robot.golden.precacheImages();
      await robot.golden.precacheDecorationImages();
      await expectLater(
        find.byType(SignUpPage),
        matchesGoldenFile(
          currentVariant.getGoldenFileName('sign_up_page'),
        ),
      );
    },
    variant: tabletVariants,
    tags: ['golden', 'layout', 'tablet', 'ios'],
    skip: false,
  );
}
