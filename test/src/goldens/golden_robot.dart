import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform/platform.dart';

/// Helper class with some helper methods for golden image tests
class GoldenRobot {
  GoldenRobot(this.tester);
  final WidgetTester tester;

  Future<void> loadAllFonts() async {
    await loadMaterialIconFont();
    //TODO: Uncomment this line when the PiixIcons font is added to the project
    // await loadAppIconFont();
    await loadRalewayFont();
  }

  /// Loads the cached material icon font.
  /// Only necessary for golden tests. Relies on the tool updating cached assets
  /// before running tests. More info here:
  /// https://stackoverflow.com/questions/65191069/golden-tests-with-custom-icon-font-class
  Future<void> loadMaterialIconFont() async {
    const fs = LocalFileSystem();
    const platform = LocalPlatform();
    final flutterRoot = fs.directory(platform.environment['FLUTTER_ROOT']);

    final iconFont = flutterRoot.childFile(
      fs.path.join(
        'bin',
        'cache',
        'artifacts',
        'material_fonts',
        'MaterialIcons-Regular.otf',
      ), //Same as bin/cache/artifacts/material_fonts/MaterialIcons_Regular.otf
    );

    final bytes =
        Future<ByteData>.value(iconFont.readAsBytesSync().buffer.asByteData());

    final fontLoader = FontLoader('MaterialIcons')..addFont(bytes);
    await fontLoader.load();
  }

  ///Load PiixIcons from the assets
  Future<void> loadAppIconFont() async {
    final appIconsFont = rootBundle.load('assets/icons/PiixIcons.ttf');
    final fontLoader = FontLoader('PiixIcons')..addFont(appIconsFont);
    await fontLoader.load();
  }

  /// Load 'Raleway' font and variants from the assets
  Future<void> loadRalewayFont() async {
    final font700Regular =
        rootBundle.load('assets/fonts/Raleway/Raleway-Regular.ttf');
    final font700Bold =
        rootBundle.load('assets/fonts/Raleway/Raleway-Bold.ttf');
    final font500SemiBold =
        rootBundle.load('assets/fonts/Raleway/Raleway-SemiBold.ttf');
    final font900ExtraBold =
        rootBundle.load('assets/fonts/Raleway/Raleway-ExtraBold.ttf');
    final fontLoader = FontLoader('Raleway')
      ..addFont(font700Regular)
      ..addFont(font700Bold)
      ..addFont(font500SemiBold)
      ..addFont(font900ExtraBold);
    await fontLoader.load();
  }

  /// Precache images for all widgets of type [Image]
  Future<void> precacheImages() async {
    final finder = find.byType(Image);
    final matches = finder.evaluate();
    if (matches.isNotEmpty) {
      await tester.runAsync(() async {
        for (final match in matches) {
          final image = match.widget as Image;
          await precacheImage(image.image, match);
        }
      });
    }
    await tester.pumpAndSettle();
  }

  /// Precache images for all widgets of type [DecorationImage]
  Future<void> precacheDecorationImages() async {
    final finder = find.byType(Container);
    final matches = finder.evaluate();
    if (matches.isNotEmpty) {
      await tester.runAsync(() async {
        for (final match in matches) {
          final container = match.widget as Container;
          final decoration = container.decoration as BoxDecoration?;
          final decorationImage = decoration?.image;
          if (decorationImage != null) {
            final image = decorationImage.image as AssetImage;
            await precacheImage(image, match);
          }
        }
      });
    }
    await tester.pumpAndSettle();
  }

  /// Precache pictures for all widgets of type [SvgPicture]
  Future<void> precacheSvgs() async {
    final finder = find.byType(SvgPicture);
    final matches = finder.evaluate();
    if (matches.isNotEmpty) {
      await tester.runAsync(() async {
        for (final match in matches) {
          final svg = match.widget as SvgPicture;
          await precachePicture(svg.pictureProvider, match);
        }
      });
    }
    await tester.pumpAndSettle();
  }

  /// Sets the surface size.
  /// Useful for generating golden image tests of different sizes
  Future<void> setSurfaceSize(Size size) async {
    //* Currently golden test are unable to work with SystemChrome.setPreferredOrientations //
    await tester.binding.setSurfaceSize(size);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    tester.view.display.size = size;
  }
}
