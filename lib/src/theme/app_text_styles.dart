import 'package:flutter/rendering.dart';
import 'package:piix_mobile/src/theme/piix_colors.dart';

const fontFamily = 'Raleway';
const textBaseHeight = 1.17;

/// A class that holds all the base text styles for the app.
/// Used in the TextTheme property of the app ThemeData class.
class TextBaseStyle {
  static TextStyle get displayLarge => const TextStyle(
        fontSize: 26,
        height: textBaseHeight,
        letterSpacing: 0.2,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get displayMedium => const TextStyle(
        fontSize: 24,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get displaySmall => const TextStyle(
        fontSize: 20,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get headlineLarge => const TextStyle(
        fontSize: 18,
        height: textBaseHeight,
        letterSpacing: 0.4,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get headlineMedium => const TextStyle(
        fontSize: 16,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get headlineSmall => const TextStyle(
        fontSize: 14,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get titleLarge => const TextStyle(
        fontSize: 16,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get titleMedium => const TextStyle(
        fontSize: 14,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  //Not defined yet
  static TextStyle get titleSmall => const TextStyle(
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get labelLarge => const TextStyle(
        fontSize: 11,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get labelMedium => const TextStyle(
        fontSize: 10,
        height: textBaseHeight,
        letterSpacing: 0.4,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  //Not defined yet
  static TextStyle get labelSmall => const TextStyle(
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  //Not defined yet
  static TextStyle get bodyLarge => const TextStyle(
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontSize: 12,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  //Not defined yet
  static TextStyle get bodySmall => const TextStyle(
        fontSize: 8,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );
}

class TextPrimaryStyle {
  //Not defined yet
  static TextStyle get displayLarge => const TextStyle(
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get displayMedium => const TextStyle(
        fontSize: 16,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );
  //Not defined yet
  static TextStyle get displaySmall => const TextStyle(
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  //Not defined yet
  static TextStyle get headlineLarge => const TextStyle(
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get headlineMedium => const TextStyle(
        fontSize: 16,
        height: textBaseHeight,
        letterSpacing: 0.17,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get headlineSmall => const TextStyle(
        fontSize: 14,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  //Not defined yet
  static TextStyle get titleLarge => const TextStyle(
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get titleMedium => const TextStyle(
        fontSize: 12,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get titleSmall => const TextStyle(
        fontSize: 12,
        height: textBaseHeight,
        letterSpacing: 0.4,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get labelLarge => const TextStyle(
        fontSize: 12,
        height: textBaseHeight,
        letterSpacing: 0.4,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get labelMedium => const TextStyle(
        fontSize: 10,
        height: textBaseHeight,
        letterSpacing: 0.4,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get labelSmall => const TextStyle(
        fontSize: 10,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  //Not defined yet
  static TextStyle get bodyLarge => const TextStyle(
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontSize: 12,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w300,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );

  //Not defined yet
  static TextStyle get bodySmall => const TextStyle(
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontFamily: fontFamily,
        color: PiixColors.infoDefault,
      );
}

class TextAccentStyle {
  static TextStyle get displayLarge => const TextStyle(
        fontSize: 20,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
      );

  static TextStyle get displayMedium => const TextStyle(
        fontSize: 16,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
      );

  static TextStyle get displaySmall => const TextStyle(
        fontSize: 16,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
      );

  static TextStyle get headlineLarge => const TextStyle(
        fontSize: 14,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
      );

  static TextStyle get headlineMedium => const TextStyle(
        fontSize: 14,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
      );

  static TextStyle get headlineSmall => const TextStyle(
        fontSize: 12,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
      );

  static TextStyle get titleLarge => const TextStyle(
        fontSize: 12,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
      );

  static TextStyle get titleMedium => const TextStyle(
        fontSize: 12,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
      );

  static TextStyle get titleSmall => const TextStyle(
        fontSize: 12,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
      );

  static TextStyle get labelLarge => const TextStyle(
        fontSize: 10,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
      );

  static TextStyle get labelMedium => const TextStyle(
        fontSize: 11,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
      );

  static TextStyle get labelSmall => const TextStyle(
        fontSize: 10,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
      );

  static TextStyle get bodyLarge => const TextStyle(
        fontSize: 12,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontSize: 10,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontSize: 9,
        height: textBaseHeight,
        letterSpacing: 0.1,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
      );
}
