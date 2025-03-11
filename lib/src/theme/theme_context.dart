import 'package:flutter/material.dart';
import 'package:piix_mobile/src/theme/theme_barrel_file.dart';

/// An extension that provides a getter for the theme of the current context.
extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);

  ThemeData get accentTheme => theme.copyWith(
          primaryTextTheme: TextTheme(
        displayLarge: TextAccentStyle.displayLarge.copyWith(
          color: PiixColors.infoDefault,
        ),
        displayMedium: TextAccentStyle.displayMedium
            .copyWith(color: PiixColors.infoDefault),
        displaySmall: TextAccentStyle.displaySmall.copyWith(
          color: PiixColors.infoDefault,
        ),
        headlineLarge: TextAccentStyle.headlineLarge.copyWith(
          color: PiixColors.primary,
        ),
        headlineMedium: TextAccentStyle.headlineMedium.copyWith(
          color: PiixColors.highlight,
        ),
        headlineSmall: TextAccentStyle.headlineSmall.copyWith(
          color: PiixColors.active,
        ),
        titleLarge: TextAccentStyle.titleLarge.copyWith(
          color: PiixColors.infoDefault,
        ),
        titleMedium: TextAccentStyle.titleMedium.copyWith(
          color: PiixColors.infoDefault,
        ),
        titleSmall: TextAccentStyle.titleSmall.copyWith(
          color: PiixColors.highlight,
        ),
        labelLarge: TextAccentStyle.labelLarge.copyWith(
          color: PiixColors.primary,
        ),
        labelMedium: TextAccentStyle.labelMedium.copyWith(
          color: PiixColors.infoDefault,
        ),
        labelSmall: TextAccentStyle.labelSmall.copyWith(
          color: PiixColors.primary,
        ),
        bodyLarge: TextAccentStyle.bodyLarge.copyWith(
          color: PiixColors.primary,
        ),
        bodyMedium: TextAccentStyle.bodyMedium.copyWith(
          color: PiixColors.infoDefault,
        ),
        bodySmall: TextAccentStyle.bodySmall.copyWith(
          color: PiixColors.highlight,
        ),
      ));

  
}
