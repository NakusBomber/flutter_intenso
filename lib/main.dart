import 'package:flutter/material.dart';
import 'package:flutter_intenso/pages/home.dart';
import 'package:flutter_intenso/pages/parfums.dart';

void main() => runApp(const IntensoApp());


class IntensoApp extends StatelessWidget {
  const IntensoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intenso',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(111, 124, 18, 1.0))
      ),
      home: const HomePage(),
      routes: {
        '/parfums': (context) => const ParfumPage()
      },
    );
  }
}
