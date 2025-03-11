import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/theme/app_text_styles.dart';
import 'package:piix_mobile/src/theme/piix_colors.dart';

/// A class that holds the app theme data.
class AppTheme {
  static ThemeData get themeData => ThemeData(
        primaryColor: PiixColors.primary,
        disabledColor: PiixColors.inactive,
        primaryColorLight: PiixColors.active,
        focusColor: PiixColors.primary,
        hoverColor: PiixColors.primary,
        splashColor: PiixColors.primary,
        hintColor: PiixColors.infoDefault,
        fontFamily: 'Raleway',
        scaffoldBackgroundColor: PiixColors.primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextBaseStyle.bodyMedium,
          labelStyle: TextBaseStyle.titleMedium.copyWith(
            color: PiixColors.infoDefault,
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: PiixColors.active,
            ),
          ),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: PiixColors.inactive,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: PiixColors.primary,
            ),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: PiixColors.error,
            ),
          ),
          focusColor: PiixColors.primary,
          hoverColor: PiixColors.primary,
          fillColor: PiixColors.active,
          errorStyle: TextBaseStyle.labelMedium.copyWith(
            color: PiixColors.error,
          ),
        ),
        textTheme: TextTheme(
          displayLarge: TextBaseStyle.displayLarge,
          displayMedium: TextBaseStyle.displayMedium,
          displaySmall: TextBaseStyle.displaySmall,
          headlineLarge: TextBaseStyle.headlineLarge,
          headlineMedium: TextBaseStyle.headlineMedium,
          headlineSmall: TextBaseStyle.headlineSmall,
          titleLarge: TextBaseStyle.titleLarge,
          titleMedium: TextBaseStyle.titleMedium,
          titleSmall: TextBaseStyle.titleSmall,
          labelLarge: TextBaseStyle.labelLarge,
          labelMedium: TextBaseStyle.labelMedium,
          labelSmall: TextBaseStyle.labelSmall,
          bodyLarge: TextBaseStyle.bodyLarge,
          bodyMedium: TextBaseStyle.bodyMedium,
          bodySmall: TextBaseStyle.bodySmall,
        ),
        primaryTextTheme: TextTheme(
          displayLarge: TextPrimaryStyle.displayLarge,
          displayMedium: TextPrimaryStyle.displayMedium,
          displaySmall: TextPrimaryStyle.displaySmall,
          headlineLarge: TextPrimaryStyle.headlineLarge,
          headlineMedium: TextPrimaryStyle.headlineMedium,
          headlineSmall: TextPrimaryStyle.headlineSmall,
          titleLarge: TextPrimaryStyle.titleLarge,
          titleMedium: TextPrimaryStyle.titleMedium,
          titleSmall: TextPrimaryStyle.titleSmall,
          labelLarge: TextPrimaryStyle.labelLarge,
          labelMedium: TextPrimaryStyle.labelMedium,
          labelSmall: TextPrimaryStyle.labelSmall,
          bodyLarge: TextPrimaryStyle.bodyLarge,
          bodyMedium: TextPrimaryStyle.bodyMedium,
          bodySmall: TextPrimaryStyle.bodySmall,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            textStyle: WidgetStatePropertyAll<TextStyle>(
              TextPrimaryStyle.titleMedium
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(
                    horizontal: Sizes.p8.w, vertical: Sizes.p8.h)),
            backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.disabled)) {
                return PiixColors.inactive;
              }
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.pressed) ||
                  states.contains(WidgetState.selected) ||
                  states.contains(WidgetState.dragged)) {
                return PiixColors.primary;
              }
              return PiixColors.active;
            }),
            foregroundColor:
                const WidgetStatePropertyAll<Color>(PiixColors.space),
            minimumSize:
                WidgetStatePropertyAll<Size>(Size(Sizes.p40.w, Sizes.p40.h)),
            maximumSize:
                WidgetStatePropertyAll<Size>(Size(Sizes.p40.w, Sizes.p40.h)),
            shape:
                WidgetStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.p8),
            )),
            iconColor: const WidgetStatePropertyAll<Color>(PiixColors.space),
            iconSize: const WidgetStatePropertyAll<double>(Sizes.p16),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            textStyle: WidgetStatePropertyAll<TextStyle>(
              TextPrimaryStyle.titleMedium
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(
                    horizontal: Sizes.p8.w, vertical: Sizes.p8.h)),
            backgroundColor: const WidgetStatePropertyAll<Color>(
              PiixColors.space,
            ),
            overlayColor: WidgetStatePropertyAll<Color>(
              PiixColors.primary.withValues(alpha: 0.1),
            ),
            foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.disabled)) {
                return PiixColors.inactive;
              }
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.pressed) ||
                  states.contains(WidgetState.selected) ||
                  states.contains(WidgetState.dragged)) {
                return PiixColors.primary;
              }
              return PiixColors.active;
            }),
            minimumSize:
                WidgetStatePropertyAll<Size>(Size(Sizes.p16, Sizes.p40.h)),
            maximumSize:
                WidgetStatePropertyAll<Size>(Size(Sizes.p16, Sizes.p64.h)),
            side: WidgetStateProperty.resolveWith((states) {
              var color = PiixColors.active;
              if (states.contains(WidgetState.disabled)) {
                color = PiixColors.inactive;
              }
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.pressed) ||
                  states.contains(WidgetState.selected) ||
                  states.contains(WidgetState.dragged)) {
                color = PiixColors.primary;
              }
              return BorderSide(
                color: color,
              );
            }),
            shape: WidgetStateProperty.resolveWith<OutlinedBorder>((states) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.p8),
              );
            }),
            iconColor: const WidgetStatePropertyAll<Color>(PiixColors.space),
            iconSize: const WidgetStatePropertyAll<double>(Sizes.p16),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.disabled)) {
                return PiixColors.inactive;
              }
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.pressed) ||
                  states.contains(WidgetState.selected) ||
                  states.contains(WidgetState.dragged)) {
                return PiixColors.primary;
              }
              return PiixColors.active;
            }),
            side: const WidgetStatePropertyAll(
              BorderSide(
                color: PiixColors.space,
              ),
            ),
            overlayColor: WidgetStatePropertyAll(
              PiixColors.secondaryLight.withValues(alpha: 0.2),
            ),
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: PiixColors.primary,
          circularTrackColor: PiixColors.space,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: PiixColors.primary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextPrimaryStyle.titleMedium,
          iconTheme: const IconThemeData(
            color: PiixColors.space,
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return PiixColors.inactive;
            }

            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused) ||
                states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.selected) ||
                states.contains(WidgetState.dragged)) {
              return PiixColors.active;
            }
            return PiixColors.space;
          }),
          checkColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return PiixColors.inactive;
            }
            return PiixColors.space;
          }),
          overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return PiixColors.inactive;
            }
            return PiixColors.space;
          }),
          side: WidgetStateBorderSide.resolveWith((states) {
            var color = PiixColors.active;
            if (states.contains(WidgetState.disabled)) {
              color = PiixColors.inactive;
            }
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused) ||
                states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.selected) ||
                states.contains(WidgetState.dragged)) {
              color = PiixColors.primary;
            }
            return BorderSide(
              color: color,
            );
          }),
        ),
        cardTheme: const CardTheme(
          color: PiixColors.sky,
          surfaceTintColor: PiixColors.space,
          elevation: 2,
        ),
      );
}
