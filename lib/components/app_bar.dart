import 'package:flutter/material.dart';

class IntensoAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String titleText;

  const IntensoAppBar({
    required this.titleText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white
      ),
      centerTitle: true,
      title: Text(
          titleText,
          style: const TextStyle(color: Colors.white)
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
