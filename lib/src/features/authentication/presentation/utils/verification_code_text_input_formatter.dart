import 'package:flutter/services.dart';
import 'package:characters/characters.dart';

///Formats the text to one value only if the maxLength is 1 in all other cases
///it does nothing and returns the new value.
class VerificationCodeLengthLimitingTextInputFormatter
    extends LengthLimitingTextInputFormatter {
  VerificationCodeLengthLimitingTextInputFormatter(super.maxLength,
      {this.replaceableChar = 'u/200B'});

  final String replaceableChar;

  ///Returns the same value if [maxLength] is null, negative or
  ///greater than one.
  ///
  ///Replaces the replacable value with an empty space and returns the new value
  ///ensuring that the [TextRange] is 1 to avoid any assert errors.
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final maxLength = this.maxLength;
    //* Checks if rules apply to the text.
    if (maxLength == null ||
        maxLength == -1 ||
        newValue.text.characters.length <= maxLength) {
      return newValue;
    }
    //* Makes maxLength was declared to one.
    assert(maxLength == 1);
    //Returns the old value if the length is not the same or the value
    //does not contain the replacable character.
    if (newValue.text.characters.length <= maxLength ||
        !newValue.text.characters.contains(replaceableChar)) {
      return oldValue;
    }
    final text = newValue.text.replaceAll(replaceableChar, '');
    //* Return a new value with the text range set to 1.
    return newValue.copyWith(
      text: text,
      selection: newValue.selection.copyWith(
        baseOffset: 0,
        extentOffset: 1,
      ),
      composing: !newValue.composing.isCollapsed
          ? const TextRange(
              start: 0,
              end: 1,
            )
          : TextRange.empty,
    );
  }
}
