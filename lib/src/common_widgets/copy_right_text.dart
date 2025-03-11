
import 'package:flutter/material.dart';
import 'package:piix_mobile/src/localization/app_intl.dart';
import 'package:piix_mobile/src/theme/piix_colors.dart';
import 'package:piix_mobile/src/theme/theme_context.dart';

///Contains the legend shown for the app copyrights.
class CopyRightText extends StatelessWidget {
  const CopyRightText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.appIntl.copyright(DateTime.now().year),
      style: context.theme.textTheme.bodySmall?.copyWith(
        color: PiixColors.secondaryLight,
      ),
    );
  }
}