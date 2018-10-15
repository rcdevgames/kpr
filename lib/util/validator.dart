import 'dart:core';

class ValidationMixin {

  String validatePassword(String val) {
    if (val.isEmpty) {
      return 'Required!';
    } else if (val.length < 5) {
      return 'Password must be at least 5 characters long';
    }
    return null;
  }

  String validateEmail(String val) {
    if (val.isEmpty) {
      return 'Required!';
    } else if (!val.contains("@") && !val.contains(".")) {
      return 'Must be valid email';
    }
    return null;
  }

  String validateRequired(String val) {
    if (val.isEmpty) {
      return 'Required!';
    }
    return null;
  }

  String validateRequiredNumber(String val) {
    if (val.isEmpty) {
      return 'Required!';
    } else if (!isNumeric(val)) {
      return 'Only Number!';
    }
    return null;
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }


}