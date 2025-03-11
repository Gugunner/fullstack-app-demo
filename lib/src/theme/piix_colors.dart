import 'package:flutter/material.dart';

/// Defines a palette of colors used throughout the Piix app.
/// 
/// This abstract final class contains static constants representing
/// various colors and gradients used for UI elements across the app.
/// These include primary, secondary, success, warning, error, and
/// background colors, along with specific gradients for visual effects.
abstract final class PiixColors {
  
  /// Primary color palette for branding and key interface elements.
  static const Color primary = Color(0xFF0D47A1);
  static const Color active = Color(0xFF2962FF);
  static const Color infoDefault = Color(0xFF52595B);
  static const Color space = Color(0xFFFFFFFF);
  static const Color contrast = Color(0xFF0D0D0D);

  /// Secondary color palette for less prominent UI components.
  /// These colors are used to complement the primary palette.
  static const Color secondary = Color(0xFF8D989C);
  static const Color secondaryLight = Color(0xFFD9D9D9);
  static const Color inactive = Color(0xFFAAC0EB);

  /// Colors representing success in the app, used for positive feedback.
  static const Color success = Color(0xFF4CAF50);

  /// Warning colors for alerts and highlights to grab the user's attention.
  /// Includes colors for process indication and highlighting elements.
  static const Color highlight = Color(0xFFFF640D);
  static const Color process = Color(0xFFF0843D);
  static const Color warning = Color(0xFFFF9800);
  static const Color shine = Color(0xFFFFC107);

  /// Error colors for negative feedback or alerts within the app.
  static const Color error = Color(0xFFCD2B2B);
  static const Color alert = Color(0xFFDB5858);

  /// Background colors for various sections and elements within the app.
  /// These colors help in creating a layered and structured layout.
  static const Color stormy = Color(0xFFEDEFF3);
  static const Color cloud = Color(0xFFF3F3F3);
  static const Color sky = Color(0xFFFAFAFA);

  /// Colors associated with specific benefits in the app.
  /// These colors help differentiate between different types of benefits.
  static const Color assist = Color(0xFF7CB342);
  static const Color insurance = Color(0xFF2196F3);
  static const Color services = Color(0xFFD81B60);
  static const Color rewards = Color(0xFF512EA8);

  /// Defines a linear gradient used in backgrounds or elements requiring 
  /// a gradient.
  /// The gradient transitions from a lighter to a darker shade of blue.
  static const LinearGradient linearGradient = LinearGradient(
    colors: [Color(0xFFECF1FB), Color(0xFFF1F5FB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  /// Colors representing different membership levels in the app.
  /// These colors are used to visually distinguish between user levels.
  static const Color piixBasic = Color(0xFF90A4AE);
  static const Color piixPremium = Color(0xFF154360);
  static const Color nC = Color(0xFFE7C36D);
}
