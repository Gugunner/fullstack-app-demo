import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'device_sizes.dart';

///The device types that the app can run on when testing.
enum Device {
  tablet,
  mobile,
}

///The file types that the golden test can be saved as.
enum FileType {
  png,
  jpg,
  jpeg,
}

///A class that stores the platform, size, and device type
///to generate a variant used for golden tests.
class GoldenVariant {
  const GoldenVariant(
    this.platform,
    this.size, [
    this.device,
  ]);

  ///The platform where the test is will be run.
  final TargetPlatform? platform;

  ///The size of the device where the test will be run.
  final Size size;

  ///The device type where the test will be run
  ///if null is web and has no device.
  final Device? device;

  ///Returns the current platform as a string.
  String get currentPlatform {
    if (platform == null) return '';
    if (platform == TargetPlatform.android || platform == TargetPlatform.iOS) {
      return platform!.name;
    }
    return 'web';
  }

  ///Returns the golden file name with the given [prefix].
  ///A [format] can be passed to change the format of the file to
  ///[png, jpg, jpeg], by default is 'png'.
  String getGoldenFileName(String prefix, {FileType type = FileType.png}) {
    var fileName = prefix;
    fileName += '_${currentPlatform}';
    //If the device is not null then add the device name to the file name
    if (device != null) {
      fileName += '_${device!.name}';
    }
    fileName += '_${size.width.toInt()}';
    fileName += 'x';
    fileName += '_${size.height.toInt()}';
    fileName += '.${type.name}';
    return fileName;
  }
}

final webVariants = ValueVariant({
  const GoldenVariant(TargetPlatform.macOS, DeviceSizes.webMobile),
  const GoldenVariant(TargetPlatform.macOS, DeviceSizes.webTablet),
  const GoldenVariant(TargetPlatform.macOS, DeviceSizes.webDesktop),
});

final mobileVariants = ValueVariant({
  const GoldenVariant(
      TargetPlatform.android, DeviceSizes.phoneXSPortrait, Device.mobile),
  const GoldenVariant(
      TargetPlatform.android, DeviceSizes.phoneSMPortrait, Device.mobile),
  const GoldenVariant(
      TargetPlatform.android, DeviceSizes.phoneLGPortrait, Device.mobile),
  const GoldenVariant(
      TargetPlatform.android, DeviceSizes.phoneXLPortrait, Device.mobile),
});

final tabletVariants = ValueVariant({
  const GoldenVariant(
      TargetPlatform.iOS, DeviceSizes.tabletMPortrait, Device.tablet),
  const GoldenVariant(
      TargetPlatform.iOS, DeviceSizes.tabletXLPortrait, Device.tablet),
  const GoldenVariant(
      TargetPlatform.iOS, DeviceSizes.tabletMLandscape, Device.tablet),
  const GoldenVariant(
      TargetPlatform.iOS, DeviceSizes.tabletXLLandscape, Device.tablet),
});
