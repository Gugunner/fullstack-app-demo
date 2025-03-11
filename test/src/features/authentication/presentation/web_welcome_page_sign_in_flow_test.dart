import 'package:flutter_test/flutter_test.dart';
import 'package:piix_mobile/src/constants/widget_keys.dart';

import '../../../robot.dart';

void main() {
  testWidgets('Web welcome page sign ina flow', (tester) async {
    final robot = Robot(tester);
    await robot.pumpMyAppWithFakes(
      isWeb: true,
      initialUserEmail: robot.auth.testSignInEmail,
    );
    robot.expectToFindWelcomePage();
    await robot.auth.enterEmail(robot.auth.testSignInEmail);
    await robot.auth.tapButtonByKey(widgetKey: WidgetKeys.submitEmailButton);
    robot.auth.expectEmailVerificationCodePage();
    await robot.auth.enterVerificationCode();
    await robot.auth
        .tapButtonByKey(widgetKey: WidgetKeys.submitVerificationCodeButton);
    robot.expectToFindHomePage();
  });
}
