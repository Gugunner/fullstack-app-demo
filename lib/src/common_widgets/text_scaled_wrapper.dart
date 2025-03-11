import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piix_mobile/app_bootstrap.dart';
import 'package:piix_mobile/src/utils/text_scale_factor_mixin.dart';

/// A wrapper widget to provide text scaling based on the screen width.
class TextScaledWrapper extends ConsumerWidget with TextScaleFactor {
  const TextScaledWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //* Read the [isWebProvider] to determine if the app is running on the web.
    final isWeb = ref.read(isWebProvider);
    final mediaQueryContext = MediaQuery.of(context);
    //* Get the screen width.
    final maxWidth = mediaQueryContext.size.width;
    //* Get the [TextScaler] based on the screen width.
    final textScaler = textScalerFromWidth(maxWidth, isWeb: isWeb);
    //* This is a way to provide a new [TextScaler] to the child widget.
    return MediaQuery(
      data: mediaQueryContext.copyWith(textScaler: textScaler),
      child: child,
    );
  }
}
