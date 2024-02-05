import 'package:flutter/material.dart';

class MyRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static push({required Widget screen}) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  static pop() {
    navigatorKey.currentState?.pop();
  }

  static pushReplace({required Widget screen}) {
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  static pushRemoveUntil({required Widget screen}) {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => screen,
      ),
      (route) => false,
    );
  }

  static void pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    navigatorKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  static void pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    navigatorKey.currentState?.pushReplacementNamed<T, TO>(routeName,
        arguments: arguments, result: result);
  }

  static void pushNamedAndRemoveUntil<T extends Object?>(
  String newRouteName,
   {RoutePredicate? predicate,
  Object? arguments,
}) {
   navigatorKey.currentState?.pushNamedAndRemoveUntil(newRouteName,predicate??(route) => false,);
}
}
