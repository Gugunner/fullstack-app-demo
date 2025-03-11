import 'dart:ui';
///Sizes used for testing purposes specially
///integration and golden tests.
///
//* Currently golden test are unable to work with SystemChrome.setPreferredOrientations //
class DeviceSizes {
  static const webMobile = Size(360, 800);
  static const webTablet = Size(768, 1024);
  static const webDesktop = Size(1920, 1080);
  static const phoneXSPortrait = Size(320, 426);
  static const phoneXSLandscape = Size(426, 320);
  static const phoneSMPortrait = Size(375, 667);
  static const phoneSMLandscape = Size(667, 375);
  static const phoneLGPortrait = Size(393, 852);
  static const phoneLGLandscape = Size(852, 393);
  static const phoneXLPortrait = Size(430, 932);
  static const phoneXLLandscape = Size(932, 430);
  static const tabletSMPortrait = Size(744, 1133);
  static const tabletSMLandscape = Size(1133, 744);
  static const tabletMPortrait = Size(820, 1180);
  static const tabletMLandscape = Size(1180, 820);
  static const tabletXLPortrait = Size(1024, 1366);
  static const tabletXLLandscape = Size(1366, 1024);
}
