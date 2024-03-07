import 'package:flutter/material.dart';


class Navigation {
  static Future? popThenPush(BuildContext context,Widget page) async {
    Navigation.pop(context);
    return await Navigation.push(context, page);
  }

  static Future? push(BuildContext context, Widget page) async {
      return await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
  }

  static pop(BuildContext context,{dynamic value}) async {
    Navigator.pop(context, value);
  }

  static Future? pushReplacement(BuildContext context,Widget page) async {
    while (Navigator.canPop(context)) {
      Navigation.pop(context);
    }
    return await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static Future? pushAndRemoveUntil(BuildContext context,Widget page) async {
    return await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => page),
            (Route<dynamic> route) => false);
  }
}
