import 'package:flutter/material.dart';
import 'package:flutter_intenso/components/app_bar.dart';

class ParfumPage extends StatefulWidget {
  const ParfumPage({super.key});

  @override
  State<ParfumPage> createState() => _ParfumPageState();
}

class _ParfumPageState extends State<ParfumPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: IntensoAppBar('Духи')
    );
  }
}
