import 'package:flutter/material.dart';

import 'animations.dart';

PageRouteBuilder<dynamic> getPageRouteBuilder(Widget page) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
      page,
      transitionsBuilder: animationBuilderPage,
      transitionDuration: animationBuilderPageDuration);
}