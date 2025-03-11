import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:piix_mobile/app_bootstrap.dart';
import 'package:piix_mobile/app_bootstrap_fake.dart';
import 'package:piix_mobile/src/common_widgets/common_widgets_barrel_file.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/constants/screen_breakpoints.dart';
import 'package:piix_mobile/src/constants/widget_keys.dart';
import 'package:piix_mobile/src/features/authentication/presentation/authentication_page_barrel_file.dart';
import 'package:piix_mobile/src/routing/home_page.dart';
import 'package:piix_mobile/src/theme/theme_barrel_file.dart';
import 'package:piix_mobile/src/utils/set_preferred_orientations.dart';

import 'features/authentication/auth_robot.dart';
import 'goldens/golden_robot.dart';

/// A robot that helps with testing the app with fakes
/// and golden files.
///
/// It also helps with testing the app with different
/// screen sizes.
class Robot {
  Robot(this.tester, {this.locale = const Locale('en')})
      : golden = GoldenRobot(tester),
        auth = AuthRobot(tester, locale);

  final WidgetTester tester;
  final Locale locale;
  final GoldenRobot golden;
  final AuthRobot auth;

  final List<MethodCall> _methods = [];

  AppIntl get appIntl => lookupAppIntl(locale);

  /// Pumps the app with fakes and sets the locale
  /// to the given [locale].
  Future<void> pumpMyAppWithFakes({
    bool isWeb = false,
    String? initialUserEmail,
  }) async {
    const appBootstrap = AppBootstrap('fake');
    final container = await appBootstrap.createFakeProviderContainer(
      isWeb,
      initialUserEmail: initialUserEmail,
    );

    //TODO: Initialize providers here
    await addWidgetBindingsMethodListener();
    //* Initialize MyApp for the test
    await tester.pumpWidget(
      appBootstrap.createHome(container: container, locale: locale),
    );
    //* Makes sure the Page is rendered
    await tester.pumpAndSettle();
  }

  /// Pump the app with the given [page] and sets the locale
  /// to the given [locale].
  Future<void> pumpWidget(Widget page,
      {bool isWeb = false, Duration? duration}) async {
    const appBootsrap = AppBootstrap('fake');
    final container = await appBootsrap.createFakeProviderContainer(isWeb);
    await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: ScreenUtilInit(
            designSize: isWeb ? webDesignSize : appDesignSize,
            minTextAdapt: true,
            builder: ((context, child) {
              return MaterialApp(
                home: page,
                theme: AppTheme.themeData,
                locale: locale,
                supportedLocales: AppIntl.supportedLocales,
                localizationsDelegates: AppIntl.localizationsDelegates,
              );
            }),
          ),
        ),
        duration: duration);
    await tester.pumpAndSettle();
  }

  void expectToFindWelcomePage() {
    final finder = find.byType(WelcomePage);
    expect(finder, findsOneWidget);
  }

  void expectToFindHomePage() {
    final finder = find.byType(HomePage);
    expect(finder, findsOneWidget);
  }

  Future<void> tapSignInSignUpGesture({bool isSignIn = true}) async {
    final finder = find.byKey(WidgetKeys.switchSignInSignUpButton);
    expect(finder, findsOneWidget);
    final textScaled = finder.evaluate().first.widget as TextScaled;
    expect(textScaled.textSpan, isNotNull);
    final textSpan = textScaled.textSpan! as TextSpan;
    expect(textSpan.children, isNotNull);
    expect(textSpan.children, isNotEmpty);
    textSpan.visitChildren(
      (visitor) => tapGestureRecognizer(
        visitor,
        isSignIn ? appIntl.signUp : appIntl.signIn,
      ),
    );
    await tester.pumpAndSettle();
  }

  bool tapGestureRecognizer(InlineSpan visitor, String matchingText) {
    if (visitor is TextSpan && visitor.text == matchingText) {
      final tapGesture = (visitor.recognizer as TapGestureRecognizer);
      expect(tapGesture.onTap, isNotNull);
      tapGesture.onTap!();
      return false;
    }
    return true;
  }

  /// Adds a listener to the SystemChannels.platform channel
  Future<void> addWidgetBindingsMethodListener() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform,
            (MethodCall methodCall) async {
      //* Each method call is added to the _methods list
      _methods.add(methodCall);
      return null;
    });
  }

  /// Expects a call to setPreferredOrientations based on the
  /// test screen size.
  Future<void> expectCallSetPrefferedOrientations(Size size) async {
    setPreferredOrientations(size.width, size.height);
    expect(_methods, isNotEmpty);
    if (size.width >= ScreenBreakPoint.md &&
        size.height >= ScreenBreakPoint.md) {
      expect(
          _methods.first,
          isMethodCall('SystemChrome.setPreferredOrientations',
              arguments: <String>[
                'DeviceOrientation.landscapeLeft',
                'DeviceOrientation.landscapeRight',
                'DeviceOrientation.portraitDown',
                'DeviceOrientation.portraitUp',
              ]));
    } else {
      expect(
          _methods.first,
          isMethodCall('SystemChrome.setPreferredOrientations',
              arguments: <String>[
                'DeviceOrientation.portraitDown',
                'DeviceOrientation.portraitUp',
              ]));
    }
  }
}
