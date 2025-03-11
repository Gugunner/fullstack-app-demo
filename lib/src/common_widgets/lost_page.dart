import 'package:flutter/material.dart';
import 'package:piix_mobile/src/common_widgets/text_scaled.dart';
import 'package:piix_mobile/src/localization/app_intl.dart';
import 'package:piix_mobile/src/theme/piix_colors.dart';
import 'package:piix_mobile/src/theme/theme_context.dart';
import 'package:piix_mobile/src/utils/size_context.dart';

/// A page that is shown when the user navigates to a non-existent route.
class LostPage extends StatelessWidget {
  const LostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.screenWidth,
        height: context.screenHeight,
        child: Center(
          child: TextScaled(
            text: context.appIntl.seemsYouAreLost,
            style: context.theme.textTheme.displayMedium?.copyWith(
              color: PiixColors.space,
            ),
          ),
        ),
      ),
    );
  }
}
