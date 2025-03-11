import 'package:flutter_test/flutter_test.dart';
import 'package:piix_mobile/src/constants/widget_keys.dart';

import '../../../robot.dart';

void main() {
  testWidgets('Web create account flow', (tester) async {
    final robot = Robot(tester);
    await robot.pumpMyAppWithFakes(isWeb: true);
    robot.expectToFindWelcomePage();
    await robot.tapSignInSignUpGesture();
    robot.auth.expectSignUpPage();
    await robot.auth.tapTermsAndPrivacyCheckBox();
    await robot.auth.enterEmail(robot.auth.testSignUpEmail);
    await robot.auth.tapButtonByKey(widgetKey: WidgetKeys.submitEmailButton);
    robot.auth.expectEmailVerificationCodePage();
    await robot.auth.enterVerificationCode();
    await robot.auth
        .tapButtonByKey(widgetKey: WidgetKeys.submitVerificationCodeButton);
    robot.expectToFindHomePage();
  });

  testWidgets('Mobile/Tablet create account flow', (tester) async {
    final robot = Robot(tester);
    await robot.pumpMyAppWithFakes();
    robot.expectToFindWelcomePage();
    await robot.auth.tapButtonByKey(widgetKey: WidgetKeys.signUpButton);
    robot.auth.expectSignUpPage();
    await robot.auth.tapTermsAndPrivacyCheckBox();
    await robot.auth.enterEmail(robot.auth.testSignUpEmail);
    await robot.auth.tapButtonByKey(widgetKey: WidgetKeys.submitEmailButton);
    robot.auth.expectEmailVerificationCodePage();
    await robot.auth.enterVerificationCode();
    await robot.auth
        .tapButtonByKey(widgetKey: WidgetKeys.submitVerificationCodeButton);
    robot.expectToFindHomePage();
  });
}
