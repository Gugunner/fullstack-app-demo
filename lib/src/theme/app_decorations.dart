import 'package:flutter/material.dart';
import 'package:piix_mobile/src/theme/theme_barrel_file.dart';

///Centralizes the decorations used for different [Widget].
class AppDecorations {
  static InputDecoration singleCodeBoxDecoration({
    bool filled = false,
    bool hasError = false,
    bool hover = false,
  }) =>
      InputDecoration(
        fillColor: hasError
            ? PiixColors.error
            : filled
                ? PiixColors.primary
                : null,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: hasError
                ? PiixColors.error
                : filled
                    ? PiixColors.primary
                    : hover
                        ? PiixColors.active
                        : PiixColors.infoDefault,
            width: 1,
          ),
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: PiixColors.inactive, width: 1),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: PiixColors.error, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: hasError ? PiixColors.error : PiixColors.active,
            width: 1,
          ),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: PiixColors.error, width: 1),
        ),
      );
}
