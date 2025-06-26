import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading; // Sửa: Widget? leading
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool centerTitle;
  final double elevation;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading, // Sửa: thêm this.leading
    this.backgroundColor,
    this.foregroundColor,
    this.centerTitle = true,
    this.elevation = 0,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? Colors.blueAccent,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: elevation,
      leading: leading, 
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
  );
}
