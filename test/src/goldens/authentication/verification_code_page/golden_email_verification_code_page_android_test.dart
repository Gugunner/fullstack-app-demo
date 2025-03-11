import 'package:flutter_test/flutter_test.dart';
import 'package:piix_mobile/src/features/authentication/presentation/email_verification_code_page.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

import '../../../robot.dart';
import '../../golden_variant.dart';

void main() {
  const testEmail = 'email@gmail.com';
  const testVerificationType = VerificationType.login;
  testWidgets(
    'Golden Email Verfication Code Page',
    (tester) async {
      //* This is the robot that will help us interact with the widgets
      final robot = Robot(tester);
      //* Get the current variant
      final currentVariant = mobileVariants.currentValue!;
      //* Get the current size from the current variant
      final currentSize = currentVariant.size;
      //* Setup the golden test surface size and load all the necessary fonts
      await robot.golden.setSurfaceSize(currentSize);
      await robot.golden.loadAllFonts();
      //* Pump the app with fakes
     await tester.runAsync(() async {
        //* Pump the app with fakes
        await robot.pumpWidget(
          const EmailVerificationCodePage(
            email: testEmail,
            verificationType: testVerificationType,
          ),
        );
      });
      //* Precache all the images and svgs
      await robot.golden.precacheSvgs();
      await robot.golden.precacheImages();
      await robot.golden.precacheDecorationImages();
      await expectLater(
        find.byType(EmailVerificationCodePage),
        matchesGoldenFile(
          currentVariant.getGoldenFileName('email_verification_code_page'),
        ),
      );
    },
    variant: mobileVariants,
    tags: ['golden', 'layout', 'mobile', 'android'],
    skip: false,
  );
}
