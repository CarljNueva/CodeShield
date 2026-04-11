import 'package:codeshield/screens/enemy_description/carousel_menu.dart';
import 'package:codeshield/screens/enemy_description/enemy_details.dart';
import 'package:flutter/material.dart';
import 'package:codeshield/screens/login_menu.dart';

import 'core/app_routes.dart';
import 'core/app_fonts.dart';
import 'screens/main_menu.dart';
import 'screens/about_us_menu.dart';

class MyGameApp extends StatelessWidget {
  const MyGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CodeShield",
      theme: ThemeData(
        fontFamily: AppFonts.main,
        brightness: .dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          brightness: .dark,
        ),
      ),
      initialRoute: AppRoutes.root,
      routes: {
        AppRoutes.root: (context) => const MainMenu(),
        AppRoutes.aboutUs: (context) => const AboutUsMenu(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.enemyCarousel: (context) => const EnemyCarousel(),
        AppRoutes.enemyDetails: (context) => const EnemyDetails(),
      },
    );
  }
}
