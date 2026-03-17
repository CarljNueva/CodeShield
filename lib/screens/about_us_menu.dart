import 'package:flutter/material.dart';
import 'package:codeshield/core/app_assets.dart';
import 'package:codeshield/core/app_text_styles.dart';

import 'package:codeshield/widgets/game_app_bar.dart';

class AboutUsMenu extends StatelessWidget {
  const AboutUsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    Widget dpRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Stack(
            alignment: AlignmentGeometry.bottomCenter,
            children: [
              Image.asset(AppImages.dpIsaac),
              Text(
                "Isaac Marcus Santos",
                style: AppTextStyles.profileText,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            alignment: AlignmentGeometry.bottomCenter,
            children: [
              Image.asset(AppImages.dpPlaceholder),
              Text(
                "Emmanuel Cerafica",
                style: AppTextStyles.profileText,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            alignment: AlignmentGeometry.bottomCenter,
            children: [
              Image.asset(AppImages.dpCarl),
              Text(
                "Carl Nueva",
                style: AppTextStyles.profileText,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            alignment: AlignmentGeometry.bottomCenter,
            children: [
              Image.asset(AppImages.dpPlaceholder),
              Text(
                "Airamei Lindo",
                style: AppTextStyles.profileText,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );

    Widget scrollView = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("ABOUT", style: AppTextStyles.titleText),
          const SizedBox(height: 16),
          Text(
            "A mobile learning app that inspires to learn cybersecurity "
            "education through an arcade style defense game inspired by "
            "the 1978 Retro Arcade Game Space Invaders. The user will take "
            "the role as the Cyber Guardian where the task is to defend "
            "the central network server from waves of invading ships "
            "representing incoming cyber-attacks.",
            style: AppTextStyles.bodyText,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 32),
          Text("DEVELOPERS", style: AppTextStyles.titleText),
          dpRow,
        ],
      ),
    );

    return Scaffold(
      appBar: MenuAppBar(),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(AppImages.menuBackgroundFull, fit: BoxFit.cover),
          ),
          SafeArea(child: scrollView),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 16.0),
          child: Text(
            "Made by the students of the "
            "Technological Institute of the Philippines",
            style: AppTextStyles.bodyText.copyWith(fontSize: 32),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
