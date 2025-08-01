class Validator {
  Validator._();

  static bool matchPhoneNumber(String value) {
    String pattern = r'((\+993)[0-9]{8}$)';
    // String pattern =
    //     r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$';
    RegExp regExp = RegExp(pattern);
    return value.isNotEmpty && regExp.hasMatch(value);
  }

  static bool matchPhoneNumberWithoutPrefix(String value) {
    String pattern = r'(^[0-9]{8}$)';
    RegExp regExp = RegExp(pattern);
    return value.isNotEmpty && regExp.hasMatch(value);
  }

  static bool matchCode(String value) {
    String pattern = r'(^[0-9]{6}$)';
    RegExp regExp = RegExp(pattern);
    return value.isNotEmpty && regExp.hasMatch(value);
  }

  static bool matchNumber(String value) {
    String pattern = r'(^[0-9]$)';
    RegExp regExp = RegExp(pattern);
    return value.isNotEmpty && regExp.hasMatch(value);
  }

  static bool matchEmail(String value) {
    String pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
    RegExp regExp = RegExp(pattern);
    return value.isNotEmpty && regExp.hasMatch(value);
  }

  static bool matchPassword(String value) {
    // Minimum eight characters, at least one uppercase letter, one lowercase letter and one number
    String pattern = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$";
    RegExp regExp = RegExp(pattern);
    return value.isNotEmpty && regExp.hasMatch(value);
  }

  static bool matchAsciiText(String value) {
    String pattern = r'(^[a-zA-Z]+$)';
    RegExp regExp = RegExp(pattern);
    return value.isNotEmpty && regExp.hasMatch(value);
  }

  static bool matchAsciiTextWithSymbols(String value) {
    String pattern = r'(^[\x00-\x7F]+$)';
    RegExp regExp = RegExp(pattern);
    return value.isNotEmpty && regExp.hasMatch(value);
  }

  static bool matchNumbersWithSymbols(String value) {
    String pattern = r'@"^([0-9]|#|\+|\*)+$"';
    RegExp regExp = RegExp(pattern);
    return value.isNotEmpty && regExp.hasMatch(value);
  }
}
