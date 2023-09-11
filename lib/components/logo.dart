import 'package:flutter/material.dart';

Column get logo {
  return const Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'INTENSO',
            style: TextStyle(
                fontFamily: "BlackerSans",
                fontWeight: FontWeight.w700,
                fontSize: 60),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'PARFUM',
            style: TextStyle(
                fontFamily: 'BlackerSans',
                fontWeight: FontWeight.w700,
                fontSize: 22),
          )
        ],
      )
    ],
  );
}