import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piix_mobile/src/features/authentication/presentation/create_account_sign_in_page_controller.dart';
import 'package:piix_mobile/src/localization/app_intl.dart';
import 'package:piix_mobile/src/theme/piix_colors.dart';
import 'package:piix_mobile/src/utils/size_context.dart';


//TODO: Implement HomePage in next step of Stage 1
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: PiixColors.highlight,
      child: Center(
        child: SizedBox(
          width: context.screenWidth * 0.65,
          child: ElevatedButton(
            onPressed: () {
              ref
                  .read(createAccountSignInControllerProvider.notifier)
                  .signOut();
            },
            child: Text(
              context.appIntl.signOut,
            ),
          ),
        ),
      ),
    );
  }
}
