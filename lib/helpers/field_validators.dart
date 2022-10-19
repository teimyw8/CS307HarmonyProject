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
    if (value.length < 6) {
      return "Must be at least 6 characters long.";
    }
    return null;
  }

  static String? validateReenterPassword(String? value, String password) {
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

  static String? validateUserName(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a username.';
    }
    if (!RegExp(r'^[A-Za-z0-9.]+$').hasMatch(value)) {
      return 'Username can only contain letter, digits, and a period';
    }
    if (value.length < 5 || value.length > 15) {
      return "Must be between 5-15 characters long.";
    }
    return null;
  }

  static String? validateBio(String? value) {
    if (value!.length > 140) return "Can't be more than 140 characters";
    return null;
  }
}