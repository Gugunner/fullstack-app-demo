import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piix_mobile/app_bootstrap.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:flutter_gen/gen_l10n/app_intl.dart';
import 'package:piix_mobile/src/localization/app_intl.dart';
import 'package:piix_mobile/src/routing/app_router.dart';
import 'package:piix_mobile/src/theme/theme_barrel_file.dart';
import 'package:piix_mobile/src/theme/theme_context.dart';
import 'package:piix_mobile/src/utils/set_preferred_orientations.dart';

/// The main entry point for the app.
class MyApp extends ConsumerStatefulWidget {
  const MyApp({
    super.key,
    this.locale,
  });

  final Locale? locale;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  FlutterView? _view;

  @override
  void initState() {
    super.initState();
    // * Save the platform where the app is running
    WidgetsBinding.instance
      // * Add the this Widget to the observer so that it can listen to changes
      ..addObserver(this)
      ..addPostFrameCallback((_) {
        _savePlatform(context);
        didChangeMetrics();
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // * Get the view from the context
    _view = View.maybeOf(context);
  }

  @override
  void dispose() {
    // * Remove the observer when the widget is disposed
    WidgetsBinding.instance.removeObserver(this);
    // * Set the view to null
    _view = null;
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final display = _view?.display;
    //If the display is null, return
    if (display == null) return;
    //Get the device width and height
    final deviceWidth = display.size.width / display.devicePixelRatio;
    final deviceHeight = display.size.height / display.devicePixelRatio;
    //Set the preferred orientations based on the device width and height
    setPreferredOrientations(deviceWidth, deviceHeight);
  }

  /// Save the platform where the app is running in the [PlatformProvider].
  Future<void> _savePlatform(BuildContext context) async {
    final platform = context.theme.platform;
    ref.read(platformProvider.notifier).state = platform;
  }

  @override
  Widget build(BuildContext context) {
    //* Watches the [GoRouter] provider
    final goRouter = ref.watch(goRouterProvider);
    final isWeb = ref.watch(isWebProvider);
    return ScreenUtilInit(
      // * Set the design size based on the platform for scaling purposes
      designSize: isWeb ? webDesignSize : appDesignSize,
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
          //go Router controls the navigation of the app
          routerConfig: goRouter,
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',
          onGenerateTitle: (context) => context.appIntl.appTitle,
          theme: AppTheme.themeData,
          locale: widget.locale,
          supportedLocales: AppIntl.supportedLocales,
          localizationsDelegates: AppIntl.localizationsDelegates,
        );
      },
    );
  }
}
