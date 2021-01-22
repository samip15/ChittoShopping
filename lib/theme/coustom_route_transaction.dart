import 'package:flutter/material.dart';

class CustomPageRoute<T> extends MaterialPageRoute<T> {
  CustomPageRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final begin = Offset(1.0, 0.0);
    final end = Offset.zero;
    final tween = Tween(begin: begin, end: end)
        .chain(CurveTween(curve: Curves.bounceInOut));
    final offSetAnimation = animation.drive(tween);
    return SlideTransition(
      position: offSetAnimation,
      child: child,
    );
  }
}

class CustomPageTransactionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    final begin = Offset(0.0, -1.0);
    final end = Offset.zero;
    final tween = Tween(begin: begin, end: end)
        .chain(CurveTween(curve: Curves.bounceInOut));
    final offSetAnimation = animation.drive(tween);
    return SlideTransition(
      position: offSetAnimation,
      child: child,
    );
  }
}
