import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.leading,
    this.actions,
    required this.asset,
    this.backgroundColor,
    this.width,
  });

  final Widget? leading;
  final List<Widget>? actions;
  final String asset;
  final Color? backgroundColor;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 90,
      elevation: 1,
      leading: leading,
      title: Image.asset(
        asset,
        width: width,
      ),
      centerTitle: true,
      actions: actions,
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.only(
      //     bottomLeft: Radius.circular(24),
      //     bottomRight: Radius.circular(24),
      //   ),
      // ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
