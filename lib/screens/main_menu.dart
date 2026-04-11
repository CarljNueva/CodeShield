import 'package:flutter/material.dart';
import 'package:codeshield/gameplay/spaceshooter.dart';
import 'package:flame/game.dart';
import 'package:codeshield/core/app_routes.dart';
import 'package:codeshield/core/app_assets.dart';
import 'package:codeshield/core/app_text_styles.dart';
import 'package:codeshield/widgets/popups/logged_out_popup.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final colMenuButtons = Column(
      crossAxisAlignment: .start,
      children: [
        TextButton(
          onPressed: () {
            runApp(GameWidget(game: SpaceShooterGame()));
          },
          child: const Text("PLAY", style: AppTextStyles.buttonLabel),
        ),

        const SizedBox(height: 20),

        TextButton(
          onPressed: () {},
          child: const Text("HOW TO PLAY", style: AppTextStyles.buttonLabel),
        ),

        const SizedBox(height: 20),

        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.enemyCarousel);
          },
          child: const Text(
            "ENEMY DESCRIPTION",
            style: AppTextStyles.buttonLabel,
          ),
        ),

        const SizedBox(height: 20),

        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.aboutUs);
          },
          child: const Text("ABOUT", style: AppTextStyles.buttonLabel),
        ),
      ],
    );

    Widget colStats = Column(
      crossAxisAlignment: .start,
      children: [
        const SizedBox(height: 125),

        Row(
          children: [
            const Text("GUEST", style: AppTextStyles.buttonLabel),
            IconButton(
              icon: Image.asset(AppIcons.edit, width: 83),
              onPressed: () {
                showLoggedOutPopup(context);
              },
            ),
          ],
        ),

        const SizedBox(height: 20),

        const Text("HIGHSCORE: 000,000,000", style: AppTextStyles.buttonLabel),
      ],
    );

    Widget colMain = Column(
      crossAxisAlignment: .center,
      children: [
        Center(child: Image.asset(AppImages.logo, width: 800)),

        const SizedBox(height: 80),

        Expanded(
          child: Row(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .start,
            children: [colMenuButtons, colStats],
          ),
        ),
      ],
    );

    final padding = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: colMain,
    );

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset(AppImages.menuBackground, fit: .cover),
          ),
          SafeArea(child: padding),
        ],
      ),
    );
  }
}
