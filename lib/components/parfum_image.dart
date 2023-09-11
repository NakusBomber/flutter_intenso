import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Image parfumImage(String url, {double size = 70}) {
  double halfSize = size / 2;
  return Image.network(
    url,
    width: size,
    height: size,
    loadingBuilder: (context, w, chunk) {
      if (chunk == null) {
        return w;
      }
      return const CircularProgressIndicator();
    },
    errorBuilder: (context, obj, trace) {
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: SvgPicture.asset(
            'assets/svg/parfum_none.svg',
            width: halfSize,
            height: halfSize,
          ),
        ),
      );
    },
  );
}
