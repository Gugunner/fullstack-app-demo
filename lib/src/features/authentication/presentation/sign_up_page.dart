import 'package:flutter/material.dart';
import 'package:piix_mobile/src/common_widgets/common_widgets_barrel_file.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/mobile_sign_in_sign_up_page.dart';
import 'package:piix_mobile/src/features/authentication/presentation/mobile_tablet/tablet_sign_in_sign_up_page.dart';
import 'package:piix_mobile/src/features/authentication/presentation/web/one_column_sign_in_sign_up_submit.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

///Calls for a specific layout for the [SignInPage].
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    const verificationType = VerificationType.register;
    return const Scaffold(
      body: WebMobileTabletLayoutBuilder(
        twoColumn:
            OneColumnSignInSignUpSubmit(verificationType: verificationType),
        oneColumn:
            OneColumnSignInSignUpSubmit(verificationType: verificationType),
        tablet: TabletSignInSignUpPage(verificationType: verificationType),
        mobile: MobileSignInSignUpPage(verificationType: verificationType),
      ),
    );
  }
}
