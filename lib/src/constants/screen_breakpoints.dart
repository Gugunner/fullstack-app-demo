///These are the screen sizes that the application will be responsive to.
class ScreenBreakPoint {
  static const double sm = 300;
  static const double md = 600;
  static const double lg = 900;
  static const double xl = 1200;

  static bool showLandsapeLayout(double deviceWidth, double deviceHeight) =>
      deviceWidth >= ScreenBreakPoint.md && deviceHeight >= ScreenBreakPoint.md;
}
