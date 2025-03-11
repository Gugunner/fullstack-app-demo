import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piix_mobile/env/env_barrel.dart';
import 'package:piix_mobile/env/env_interface.dart';
import 'package:piix_mobile/src/common_widgets/common_widgets_barrel_file.dart';
import 'package:piix_mobile/src/localization/app_intl.dart';
import 'package:piix_mobile/src/my_app.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_bootstrap.g.dart';

///All avaliable environments where the app is run
///during app development cycle.
enum ENV { fake, local, dev, stage, prod }

///A provider that allows the environment to be read
///inside any Consumer Widget or Riverpod provider.
///
///Acts as a singleton.
@Riverpod(keepAlive: true)
final envProvider = StateProvider<Env?>((ref) {
  return null;
});

///A provider that stores and retrieves the platform
///where the app is currently running.

@Riverpod(keepAlive: true)
final platformProvider =
    StateProvider<TargetPlatform>((ref) => TargetPlatform.android);

///A provider that reads if the app is running a web version
///regardless of the platform where it is running by reading [kIsWeb].
///
///Oveeride the value for testing purposes on web.
@Riverpod(keepAlive: true)
bool isWeb(IsWebRef ref) {
  return kIsWeb;
}

/// An auxiliary class to bootstrap the app with the given environment
class AppBootstrap {
  const AppBootstrap(this.env);

  ///The environment to use between fake, dev, stage, and prod
  final String env;

  ///Get the environment values from the environment variables
  Env? get environment {
    if (env == ENV.local.name) return LocalEnv();
    if (env == ENV.dev.name) return DevEnv();
    if (env == ENV.stage.name) return StageEnv();
    if (env == ENV.prod.name) return ProdEnv();
    return null;
  }

  ///Create the home widget for the app.
  ///
  ///Pass a [locale] to set the language of the app for testing purposes.
  Widget createHome({required ProviderContainer container, Locale? locale}) {
    //Sets the environment value for the provider.
    container.read(envProvider.notifier).state = environment;
    //Initializes the platform provider before being used.
    container.read(platformProvider);
    container.read(isWebProvider);
    //TODO: Initialize providers here
    //* Set Android orientations
    if (environment != null) {
      //* This cannot be tested in any unit, widget, or integration test
      //* since it is a last resort as explained by the Flutter team in https://github.com/flutter/flutter/issues/110301 //
      _registerErrorHandlers();
    }
    return UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    );
  }

  ///Register error handlers for the app
  void _registerErrorHandlers() {
    // * Show some error UI if any uncaught exception happens
    FlutterError.onError = (FlutterErrorDetails details) {
      debugPrint('FlutterError.onError: $details');
    };
    // * Handle errors from underlying platform/OS
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      debugPrint('PlatformDispatcher.instance.onError: $error');
      return true;
    };
    // * Show some error UI when any widget in the app fails to build
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: TextScaled(text: context.appIntl.unknownError),
          ),
          body: Center(
            child: TextScaled(text: details.toString()),
          ),
        );
      });
    };
  }
}
