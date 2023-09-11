import 'package:flutter/material.dart';

class IntensoDefaultAppBar extends StatefulWidget implements PreferredSizeWidget {

  final Widget? textWidget;

  const IntensoDefaultAppBar({
    required this.textWidget,
    super.key,
  });

  @override
  State<IntensoDefaultAppBar> createState() => _IntensoDefaultAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _IntensoDefaultAppBarState extends State<IntensoDefaultAppBar> {

  TextStyle get titleTextStyle => const TextStyle(
      color: Colors.white,
      fontSize: 18
  );

  IconThemeData get iconTheme => const IconThemeData(color: Colors.white);

  Color get backgroundColor => Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleTextStyle: titleTextStyle,
      iconTheme: iconTheme,
      centerTitle: true,
      title: widget.textWidget,
      backgroundColor: backgroundColor,
    );
  }


}
