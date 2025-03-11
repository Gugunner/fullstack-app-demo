import 'package:flutter/material.dart';
import 'package:piix_mobile/src/common_widgets/common_widgets_barrel_file.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/mobile_sign_in_sign_up_page.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/tablet_sign_in_sign_up_page.dart';
import 'package:piix_mobile/src/features/authentication/presentation/web/one_column_sign_in_sign_up_submit.dart';

///Calls for a specific layout for the [SignInPage].
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WebMobileTabletLayoutBuilder(
        twoColumn: OneColumnSignInSignUpSubmit(),
        oneColumn: OneColumnSignInSignUpSubmit(),
        tablet: TabletSignInSignUpPage(),
        mobile: MobileSignInSignUpPage(),
      ),
    );
  }
}
