import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

///A class that holds the supported locales and localizations delegates.
class AppLocales {
  static List<Locale> supportedLocales = [
    const Locale('en'),
    const Locale('es'),
  ];

  static List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}
