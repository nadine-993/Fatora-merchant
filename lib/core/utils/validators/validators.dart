class Validators {
  static bool isEmptyValidator(String value) {
    return value.isNotEmpty;
  }

  static bool isPasswordValid(String password) {
    // Define a regex pattern for the password
    const pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

    // Create a regex object with the pattern
    final regex = RegExp(pattern);

    // Use the regex to match the password
    return regex.hasMatch(password);
  }
}