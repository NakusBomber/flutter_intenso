import 'package:flutter/material.dart';

class IntensoAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;

  const IntensoAppBar(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
          title,
          style: const TextStyle(color: Colors.white)
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
