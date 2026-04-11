import 'package:flutter/material.dart';
import 'package:codeshield/core/app_assets.dart';

class MenuAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MenuAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.maybePop(context),
        icon: Image.asset(AppIcons.back, filterQuality: FilterQuality.none),
        tooltip: "Go back",
      ),
      title: Image.asset(AppImages.logo, height: 40),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(3.0),
        child: Container(
          color: Colors.white.withValues(alpha: 0.1),
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
