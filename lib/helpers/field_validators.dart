class FieldValidator {
  static String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return "Email is required";
    }
    if (!RegExp(
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value)) {
      return "Please enter a valid email address";
    }

    return null;
  }

  //todo add check for username
  //todo add check if pwd contains a digit
  static String? validatePassword(String? value) {
    if (value!.isEmpty) return "Enter password";
    if (value.contains("!") || value.contains("@") || value.contains("%") || value.contains("*") || value.contains("-") || value.contains("+") || value.contains("=")) {
      return "Make sure to include a special character";
    }
    if (value.length < 6 || value.length > 15) return "Must be between 6-15 characters long.";
    return null;
  }
  static String? validateReenterPassword(
      String? value, String password) {
    if (value!.isEmpty) return "Can't be empty";
    if (value != password) return "Passwords don\'t match";
    return null;
  }

  static String? validateRegularField(String? value) {
    if (value!.isEmpty) return "Can't be empty";
    return null;
  }

  static String? validateCurrentPasswordField(
      String? value, String currentPassword) {
    if (value!.isEmpty) return "Can't be empty";
    if (value != currentPassword) return "Doesn't match with current password";
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }
}
