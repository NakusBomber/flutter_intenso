import 'package:flutter/material.dart';

Duration get animationBuilderPageDuration => const Duration(milliseconds: 500);
Duration get animationScrollToAnchorDuration => const Duration(milliseconds: 400);
Duration get animationDividerDuration => const Duration(seconds: 1, milliseconds: 500);
Duration get animationTextPrintingDuration => const Duration(seconds: 3);

Widget animationBuilderPage(context, animation, secondaryAnimation, child) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.fastOutSlowIn;

  var tween = Tween(begin: begin, end: end);
  var curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

  return SlideTransition(
    position: tween.animate(curvedAnimation),
    child: child,
  );
}

Widget animationDivider(Widget divider) {
  return TweenAnimationBuilder(
      tween: Tween<double>(begin: 400, end: 0),
      duration: animationDividerDuration,
      builder: (BuildContext context, double value, Widget? child) {
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: value),
            child: divider
        );
      });
}

Widget animationTextPrinting(String text) {
  return TweenAnimationBuilder(
      tween: IntTween(begin: 0, end: text.length),
      duration: animationTextPrintingDuration,
      builder: (BuildContext context, int value, Widget? child) {
        int length = value;
        return Text(text.substring(0, length));
      });
}
