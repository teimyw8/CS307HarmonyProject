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

  static String? validatePassword(String? value) {
    if (value!.isEmpty) return "Enter password";
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
