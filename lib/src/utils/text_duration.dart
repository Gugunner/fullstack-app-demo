
/// Extension on [Duration] to convert it to a text representation.
extension TextDuration on Duration {
  ///Convertst an integer to a string representation by dividing it by 60.
  ///and padding it.
  ///
  ///[intTime] the integer to convert to a string.
  ///[width] the width of the string, if null passes 2.
  ///[padding] the padding to use, if null passes '0'.
  String _fromInt(
    int intTime, {
    int? width,
    String? padding,
  }) =>
      intTime.remainder(60).toString().padLeft(width ?? 2, padding ?? '0');

  ///Converts the duration to minutes 'mm'.
  String fromMinutes({
    int? width,
    String? padding,
  }) =>
      _fromInt(inMinutes);

  ///Converts the duration to seconds 'ss'.
  String fromSeconds({
    int? width,
    String? padding,
  }) =>
      _fromInt(inSeconds);

  ///Converts the duration to minutes and seconds 'mm:ss'.
  String get minutesAndSeconds {
    final minutes = fromMinutes();
    final seconds = fromSeconds();
    return '$minutes:$seconds';
  }
}
