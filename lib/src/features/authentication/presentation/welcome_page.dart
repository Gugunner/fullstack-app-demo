import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piix_mobile/src/common_widgets/web_mobile_tablet_layout_builder.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/mobile_welcome_page.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/tablet_welcome_page.dart';
import 'package:piix_mobile/src/features/authentication/presentation/web/one_column_sign_in_sign_up_submit.dart';
import 'package:piix_mobile/src/features/authentication/presentation/web/two_column_sign_in.dart';

///A layout builder Widget that displays the appropriate welcome page based on
///the screen size and the platform where the app currently running.
class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: WebMobileTabletLayoutBuilder(
        twoColumn: TwoColumnSignIn(
        ),
        oneColumn: OneColumnSignInSignUpSubmit(
        ),
        tablet: TabletWelcomePage(
        ),
        mobile: MobileWelcomePage(
        ),
      ),
    );
  }
}
