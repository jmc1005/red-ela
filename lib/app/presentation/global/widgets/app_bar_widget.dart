import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.leading,
    this.actions,
    required this.asset,
    this.backgroundColor,
  });

  final Widget? leading;
  final List<Widget>? actions;
  final String asset;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 90,
      elevation: 1,
      leading: leading,
      title: Image.asset(
        asset,
        width: 56,
      ),
      centerTitle: true,
      actions: actions,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
