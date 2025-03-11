import 'package:flutter/material.dart';

///A class that extends [OutlinedButton] and scales the text based on the 
///[textScaleFactor].
///
///It also determines the [child] as a [Text] widget with the [text] aligned to
///the center.
class TextScaledOutlinedButton extends OutlinedButton {
  TextScaledOutlinedButton({
    super.key,
    required this.text,
    required this.textScaleFactor,
    required super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
  }) : super(
          child: Text(
            text,
            textScaler: TextScaler.linear(textScaleFactor),
            textAlign: TextAlign.center,
          ),
        );

  final String text;
  final double textScaleFactor;
}
