import 'package:codeshield/core/app_assets.dart';
import 'package:codeshield/core/app_fonts.dart';
import 'package:codeshield/screens/enemy_description/carousel_menu.dart';
import 'package:codeshield/widgets/game_app_bar.dart';
import 'package:flutter/material.dart';

class EnemyDetails extends StatelessWidget {
  const EnemyDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as CarouselItemData;
    final hero = Hero(
      tag: 'carousel_hero_${data.title}',
      child: Material(
        type: .transparency,
        child: Container(
          height: 600,
          width: 500,
          decoration: BoxDecoration(
            color: data.color,
            border: .all(color: Colors.white, width: 25.0),
          ),
          child: SafeArea(
            child: Center(
              child: Text(
                data.title,
                style: const TextStyle(
                  fontSize: 36.0,
                  color: Colors.white,
                  fontFamily: AppFonts.main,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final description = Padding(
      padding: const .all(24.0),
      child: Text(
        data.details,
        style: const TextStyle(
          fontSize: 20.0,
          height: 1.5,
          fontFamily: AppFonts.main,
        ),
        textAlign: .center,
      ),
    );

    return Scaffold(
      appBar: MenuAppBar(),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(AppImages.menuBackgroundAlt, fit: .cover),
          ),
          Column(
            children: [
              Text(
                "ENEMY DESCRIPTION",
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: AppFonts.main,
                  fontWeight: .bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: .center,
                crossAxisAlignment: .start,
                children: [hero, description],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
