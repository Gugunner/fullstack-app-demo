import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piix_mobile/src/constants/app_sizes.dart';
import 'package:piix_mobile/src/features/authentication/presentation/utils/verification_code_text_input_formatter.dart';
import 'package:piix_mobile/src/theme/theme_barrel_file.dart';
import 'package:piix_mobile/src/theme/theme_context.dart';

///A [TextFormField] that is customized to work with one digit
///character at a time.
///
///Each [SingleCodeBox] requires a [boxNumber] so it can be identified
///by position when updating the value inside of it.
///
///When a value is written the [Focus] jumps to the next [SingleCodeBox]
///unless it is the last 6th one, in the case it looses focus.
///When deleting a value it jumps to the previous
///[SingleCodeBox] unless it is the 1st one, in that case it looses focus.
///
///When [hasError] is passed to this it will change to the [Theme] errorColor
///to reflect that something went wrong when passing over the value.
class SingleCodeBox extends StatefulWidget {
  const SingleCodeBox(
    this.boxNumber, {
    super.key,
    required this.onChanged,
    required this.focusNode,
    this.hasError = false,
  });

  ///Identifies this if more than one [SingleCodeBox] is present.
  ///Controls if this should pass focus or not based on the number
  ///in it. If the number is 0 or 5 it will relinquish focus instead of
  ///going to the previous node or the next node respectively.
  final int boxNumber;

  ///Indicates the value that changed to the parent and the
  ///[boxNumber] that changed. Only returns a value when it
  ///can be identified as a digit.
  final Function(int, String) onChanged;

  ///Controls how each [SingleCodeBox] should pass focus
  ///when writing a value or deleting a value.
  ///Each time a digit is written the focus goes to next
  ///[SingleCodeBox] except when the [boxNumber] is 5, meaning that
  ///it has reached the end of the boxes, in that case
  ///it just relinquishes focus. It also relinquishes focus when deleting a
  ///digit value if the [boxNumber] is 0, since it is the first box, in that
  ///case it also just relinquishes focus.
  final FocusNode focusNode;

  ///Indicates whether or not this box should
  ///change its color to the [Theme] error [Color].
  final bool hasError;

  @override
  State<SingleCodeBox> createState() => _SingleCodeBoxState();
}

///Controls the appearance of the [SingleCodeBox] and builds the [Widget]
///that shows it.
///
///The appearance changes based on the value currently present in the
///[TextFormField] and whether or not it has focus.
///
///When a value different from the [invisibleChar] is entered the
///box is considered to be [filled] and will change the value's [TextStyle]
///color to the [Theme] primary color.
///
///When a mouse cursor is hovering over this it will change its color to
///the [Theme] active color to indicate that the box can become the active one.
///
///The use of the [invisibleChar] is because OS such as [Android] or [iOS]
///have software keyboards and they listen to deltas, so when the user deletes
///the value and is empty it will not detect that the user has pressed
///the backspace "key" again since there is no delta. But what is required is
///that the focus goes to the previous one when pressing backspace "key" on an
///empty [TextFormField]. By adding an [invisibleChar] instead of clearing
///the value when the backspace "key" is pressed it will instead be replaced
///with the [invisibleChar] and then detect if the delta comes from
///[invisibleChar] to empty which creates the same effect as pressing the
///backspace "key" since the user since will only see a blank field.
///
///For the [invisibleChar] to work a [TextEditingController] is used
///to initialize the value to [invisibleChar] and to listen to any changes
///using [_onListen] which replaces the value to [invisibleChar] when the
///value is cleared and the previous value was not an [invisibleChar].
///And also moves focus the previous or next [SingleCodeBox].
class _SingleCodeBoxState extends State<SingleCodeBox> {
  ///Allows to control the text of the [SingleCodeBox] and
  ///create a listener to detect changes.
  late TextEditingController codeController;

  ///Changes the value color to [Theme] primary color when
  ///a value that is not [invisibleChar] is present.
  bool filled = false;

  ///Changes the border color to [Theme] active color
  ///when the mouse cursor enters the [SingleCodeBox] area.
  bool hover = false;

  ///Replaces the empty value to detect changes when the
  ///backspace "key" is pressed, cannot be seen in the UI.
  final String invisibleChar = '\u200B';

  ///Keeps track of the previous text to detect changes.
  String prevText = '';

  @override
  void initState() {
    super.initState();
    //* Initialize a TextEditing controller with the [invisibleChar] text.
    codeController = TextEditingController(text: invisibleChar);
    //* Add the listener
    codeController.addListener(_onListen);
  }

  @override
  void dispose() {
    //* Remove the listener before disposing the Widget to prevent memory leak issues //
    codeController.removeListener(_onListen);
    //* Dispose the controller
    codeController.dispose();
    super.dispose();
  }

  ///Listens to each change controlling [filled] and focus changes as well
  ///as calling [onChanged] to update the value and pass it to the parent.
  void _onListen() {
    final text = codeController.text;
    final isInvisibleChar = text.compareTo(invisibleChar) == 0;
    setState(() {
      filled = !isInvisibleChar && text.isNotEmpty;
    });
    //* If the char is invisible there is no need to update values or check focus//
    if (isInvisibleChar) return;
    //Update the value.
    widget.onChanged.call(widget.boxNumber, text);
    //* When there is no focus then exit without doing anything//
    if (!widget.focusNode.hasPrimaryFocus && !widget.focusNode.hasFocus) return;
    //*If text is empty check if the previous text was the invisible char or not//
    if (text.isEmpty) {
      //* If the previous text was the invisible char then it means that clearing again the field will either move to the previous focused field or unfocus if at the begininning//
      if (prevText == invisibleChar) {
        if (widget.boxNumber == 0) return widget.focusNode.unfocus();
        FocusManager.instance.primaryFocus?.previousFocus();
      } else {
        //* Unfocus if pressing the backspace "key" the value is empty and it is the first box //
        codeController.text = invisibleChar;
        setState(() {
          prevText = invisibleChar;
        });
      }
      return;
    }
    //* If the text is not empty and the previous text was either empty or the invisible char then the focus can move to the next focusable field or unfocus if at the end//
    if (text.isNotEmpty && (prevText.isEmpty || prevText == invisibleChar)) {
      setState(() {
        prevText = text;
      });
      //* Unfocus if writing the last value in the last box //
      if (widget.boxNumber == 5) return widget.focusNode.unfocus();
      FocusManager.instance.primaryFocus?.nextFocus();
    }
  }

  ///Tapping outside the area will unfocus the box.
  void _onTapOutside(PointerDownEvent event) {
    //Only unfocus the TextFormField if it has focus.
    if (widget.focusNode.hasPrimaryFocus || widget.focusNode.hasFocus) {
      widget.focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: Sizes.p40.w,
        minHeight: Sizes.p48.h,
      ),
      child: MouseRegion(
        onEnter: (event) => setState(() => hover = true),
        onExit: (event) => setState(() => hover = false),
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: codeController,
          onTapOutside: _onTapOutside,
          focusNode: widget.focusNode,
          //*Request focus for the first code box.
          autofocus: widget.boxNumber == 0,
          inputFormatters: [
            VerificationCodeLengthLimitingTextInputFormatter(
              1,
              replaceableChar: invisibleChar,
            ),
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: context.theme.textTheme.displaySmall?.copyWith(
            color: filled ? PiixColors.primary : null,
          ),
          textAlign: TextAlign.center,
          decoration: AppDecorations.singleCodeBoxDecoration(
            filled: filled,
            hasError: widget.hasError,
            hover: hover,
          ),
        ),
      ),
    );
  }
}
