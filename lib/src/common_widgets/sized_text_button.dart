import 'package:flutter/material.dart';
import 'package:piix_mobile/src/theme/theme_barrel_file.dart';
import 'package:piix_mobile/src/theme/theme_context.dart';

///Values read by [SizedTextButton] to determine
///a specific [TextAccentStyle].
enum SizedText {
  small,
  medium,
  large,
}

///A custom [TextButton] that has a specific [themeStyleOf]
///override logic to use the [accentTheme] but chooses different
///[TextAccentStyle] based on the [sizedText].
class SizedTextButton extends TextButton {
  const SizedTextButton({
    super.key,
    required super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    super.isSemanticButton,
    required Widget super.child,
    this.sizedText,
  });

  ///If not null will return a specific [TextAccentStyle].
  ///If null by default it willr return [TextAccentStyle.headlineLarge].
  final SizedText? sizedText;

  /// Returns the [TextButtonThemeData.style] of the closest
  /// [accentTheme] ancestor with a specific [TextAccentStyle].
  @override
  ButtonStyle? themeStyleOf(BuildContext context) {
    return context.accentTheme.textButtonTheme.style?.copyWith(
        textStyle: WidgetStateProperty.resolveWith((states) {
      switch (sizedText) {
        case SizedText.small:
          return TextAccentStyle.titleSmall;
        case SizedText.medium:
          return TextAccentStyle.titleMedium;
        case SizedText.large:
        case null:
          return TextAccentStyle.headlineLarge;
      }
    }));
  }
}
