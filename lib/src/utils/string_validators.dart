///The interface used by the string validators.
abstract class StringValidator {
  ///Checks if a [value] is valid based on the [source] pattern.
  bool isValid(String value);
}

///A validator that checks if a [value] [isValid] based on a [RegExp].
///
///The [source] is the [RegExp] pattern that the [value] is checked against.
class RegexValidator implements StringValidator {
  const RegexValidator(this.source);
  final String source;

  ///Checks if a [value] is valid based on the [source] pattern.
  @override
  bool isValid(String value) {
    try {
      final regexp = RegExp(source);
      ///Finds all the matches in the [value] based on the [source] pattern.
      final matches = regexp.allMatches(value);
      //Loops through all the matches found.
      for (final match in matches) {
        //Check if the entire string matches the pattern
        if (match.start == 0 && match.end == value.length) {
          //If the entire string matches the pattern, return true.
          return true;
        }
      }
      //If the entire string does not match the pattern, return false.
      return false;
    } catch (e) {
      //Throw an error if the [source] pattern is invalid.
      assert(false, e.toString());
      //Return false if the [source] pattern is invalid.
      return false;
    }
  }
}

///The validator that checks if a [value] is a valid email.
class EmailStringValidator extends RegexValidator {
  //https://regexr.com/3e48o
  EmailStringValidator() : super(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
}

///The validator that checks if a [value] is not empty.
class EmptyStringValidator extends StringValidator {
  @override
  bool isValid(String value) => value.isNotEmpty;
}

///The validator that checks if a [value] is at least [minLength] 
///characters long.
class MinLengthStringValidator extends StringValidator {
  MinLengthStringValidator(this.minLength);
  final int minLength;

  @override
  bool isValid(String value) => value.length >= minLength;
}
