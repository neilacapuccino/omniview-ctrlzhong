import 'package:flutter/material.dart';
import 'main.dart';

class LogoutHelper {
  static void logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MyApp()),
      (route) => false,
    );
  }
}
//can add to reset user account login information if implemented