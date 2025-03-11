import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_intl.dart';

///An extension to obtain the [AppIntl] instance from the [BuildContext].
extension AppIntlExtension on BuildContext {
  AppIntl get appIntl => AppIntl.of(this)!;
}
