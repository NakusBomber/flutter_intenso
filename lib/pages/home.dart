import 'package:flutter/material.dart';
import 'package:flutter_intenso/components/app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: IntensoAppBar("Главный экран"),
      body: Text('bdjkwbdjk')
    );
  }
}
