import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piix_mobile/app_bootstrap.dart';
import 'package:piix_mobile/src/utils/text_scale_factor_mixin.dart';

/// A widget that returns a [Text] widget with a [textScaler] based on the 
/// screen width.
/// 
//* To see each property, see [Text].
class TextScaled extends ConsumerWidget with TextScaleFactor {
  const TextScaled({
    super.key,
    this.text,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.textSpan,
  }) : 
  //* Assert that either [text] or [textSpan] is not null.
  assert(text != null && textSpan == null ||
            text == null && textSpan != null);
  
  final String? text;

  final TextStyle? style;

  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final InlineSpan? textSpan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //* Read the [isWebProvider] to determine if the app is running on the web.
    final isWeb = ref.watch(isWebProvider);
    //* Get the screen width.
    final maxWidth = MediaQuery.of(context).size.width;
    //* Get the [TextScaler] based on the screen width.
    final textScaler = textScalerFromWidth(maxWidth, isWeb: isWeb);
    //* If [text] is not null, return a [Text] widget with the [textScaler].
    if (text != null) {
      return Text(
        text!,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaler: textScaler,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
      );
    }
    //* If [text] is null, return a [Text.rich] widget with the [textScaler].
    return Text.rich(
      textSpan!,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}
