extension StringExtension on String {
  String limit(int length) =>
      length < this.length ? substring(0, length) : this;
}

extension NullableStringExtension on String? {
  bool get isNotEmptyOrNull => this != null && this != '';
  bool get isEmptyOrNull => this == null || this == '';
}
