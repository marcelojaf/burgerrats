/// Extensions on String for common operations
extension StringExtensions on String {
  /// Capitalize the first letter of the string
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Check if the string is a valid email
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Check if the string is blank (empty or only whitespace)
  bool get isBlank => trim().isEmpty;

  /// Check if the string is not blank
  bool get isNotBlank => !isBlank;
}
