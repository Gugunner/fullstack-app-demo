import 'package:flutter/material.dart';
import 'package:piix_mobile/src/localization/string_hardcoded.dart';
import 'package:piix_mobile/src/theme/theme_barrel_file.dart';
import 'package:piix_mobile/src/theme/theme_context.dart';

/// A text field for entering an email address.
/// All the styles are loaded from Theme.of(context).
class EmailInputTextField extends StatelessWidget {
  const EmailInputTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: context.theme.textTheme.titleMedium?.copyWith(
        color: PiixColors.infoDefault,
      ),
      decoration: InputDecoration(
        hintText: 'Enter your email'.hardcoded,
        // errorText: 'Error',
      ),
    );
  }
}
