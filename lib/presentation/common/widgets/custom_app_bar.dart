import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading; // नया 'leading' विजेट यहाँ जोड़ा गया है

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading, // कंस्ट्रक्टर में इसे जोड़ें
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading, // AppBar में इसका उपयोग करें
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
