import 'package:carousel_slider/carousel_slider.dart';
import 'package:codeshield/core/app_assets.dart';
import 'package:codeshield/core/app_fonts.dart';
import 'package:codeshield/core/app_routes.dart';
import 'package:codeshield/core/carousel_data.dart';
import 'package:codeshield/widgets/game_app_bar.dart';
import 'package:flutter/material.dart';

class EnemyCarousel extends StatefulWidget {
  const EnemyCarousel({super.key});

  @override
  State<EnemyCarousel> createState() => _EnemyCarouselState();
}

class _EnemyCarouselState extends State<EnemyCarousel> {
  int _currentIndex = 0;
  final List<CarouselItemData> carouselData = [
    CarouselItemData(
      color: Colors.blueGrey,
      title: "The Ocean",
      subtitle: "Body of Water",
      details: "Deep, mysterious, and full of uncharted territories.",
    ),
    CarouselItemData(
      color: Colors.teal,
      title: "The Forest",
      subtitle: "A Bunch of Trees",
      details: "Lush, green, and teeming with wildlife.",
    ),
    CarouselItemData(
      color: Colors.indigo,
      title: "The Night Sky",
      subtitle: "Visible Post-Day",
      details: "Endless stars painting a canvas of infinity.",
    ),
    CarouselItemData(
      color: Colors.deepOrange,
      title: "The Canyon",
      subtitle: "Sandy Mountain",
      details: "Carved by time, standing tall and majestic.",
    ),
    CarouselItemData(
      color: Colors.brown,
      title: "The Mountains",
      subtitle: "Large Rock Formations",
      details: "Snow-capped peaks reaching for the clouds.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final carouselItems = carouselData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final image = data.imagePath != null
          ? DecorationImage(
              image: AssetImage(data.imagePath!),
              fit: .cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.3),
                .darken,
              ),
            )
          : null;

      return GestureDetector(
        onTap: () {
          if (_currentIndex != index) return;
          Navigator.pushNamed(context, AppRoutes.enemyDetails, arguments: data);
        },
        child: Hero(
          tag: 'carousel_hero_${data.title}',
          child: Material(
            type: .transparency,
            child: Container(
              width: 800,
              margin: const .symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: data.color,
                border: .all(color: Colors.white, width: 25.0),
                image: image,
              ),
              child: Center(
                child: Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                    fontFamily: AppFonts.main,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();

    final carouselSlider = CarouselSlider(
      options: CarouselOptions(
        height: 500,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        viewportFraction: 0.33,
        onPageChanged: (index, reason) {
          setState(() => _currentIndex = index);
        },
      ),
      items: carouselItems,
    );

    final dynamicText = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Column(
          key: ValueKey<int>(_currentIndex),
          children: [
            Text(
              carouselData[_currentIndex].title,
              style: const TextStyle(fontSize: 24, fontFamily: AppFonts.main),
            ),
            const SizedBox(height: 8),
            Text(
              carouselData[_currentIndex].details,
              textAlign: .center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: AppFonts.main,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "(Tap the highlighted card to maximize)",
              style: TextStyle(
                fontSize: 12,
                color: Colors.blueAccent,
                fontFamily: AppFonts.main,
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: MenuAppBar(),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(AppImages.menuBackgroundAlt, fit: .cover),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                carouselSlider,
                const SizedBox(height: 30),
                dynamicText,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
