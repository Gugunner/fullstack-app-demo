extension NullListCheck on List? {
  bool get isNullEmpty => this == null || this!.isEmpty;
}
