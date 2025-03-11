import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:piix_mobile/app_bootstrap.dart';
import 'package:piix_mobile/app_bootstrap_fake.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

/// The main entry point for the "fakes" project configuration
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  // * Get the environment from the environment variables
  // * Initialize the app with the environment
  const appBootstrap = AppBootstrap('fake');
  final container = await appBootstrap.createFakeProviderContainer(
    kIsWeb,
    initialUserEmail: 'test@gmail.com',
  );
  runApp(appBootstrap.createHome(container: container));
}
