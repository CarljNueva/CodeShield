import 'package:carousel_slider/carousel_slider.dart';
import 'package:codeshield/core/app_assets.dart';
import 'package:codeshield/core/carousel_data.dart';
import 'package:codeshield/widgets/game_app_bar.dart';
import 'package:codeshield/screens/how_to_play/carousel_item.dart';
import 'package:flutter/material.dart';

const double modifier = 0.75;
const double frameWidth = 1280.0 * modifier;
const double frameHeight = 720.0 * modifier;

class HowToPlayMenu extends StatefulWidget {
  const HowToPlayMenu({super.key});

  @override
  State<HowToPlayMenu> createState() => _HowToPlayMenuState();
}

class _HowToPlayMenuState extends State<HowToPlayMenu> {
  int _currentIndex = 0;
  // TODO: Make videos for the tutorials
  final List<CarouselItemData> tutorialData = [
    CarouselItemData(
      color: Colors.blue,
      title: "MOVEMENT / GAMEPLAY",
      videoPath: AppVideos.bomboclat,
      details:
          "Drag the player all across the screen to move and shoot "
          "the upcoming enemies.",
    ),
    CarouselItemData(
      color: Colors.blueAccent,
      title: "OBJECTIVE",
      details:
          "Cyber threats are coming from the right to attack your home server. "
          "Your goal is to protect the server from these attacks "
          "using your abilities.",
    ),
    CarouselItemData(
      color: Colors.blueGrey,
      title: "WAVE LOGIC",
      details:
          "Each waves represents an OSI Layer from 3 to 7. Each waves "
          "contain an exclusive cyberattack enemy that requires a "
          "different solution to beat them.",
    ),
    CarouselItemData(
      color: Colors.orange,
      title: "POWER-UP DROPS",
      details:
          "Each enemy has chance to drop a power-up. These power-up help "
          "the players eliminate enemies or either protect the server.",
    ),
    CarouselItemData(
      color: Colors.purple,
      title: "WEAPON TYPES / ABILITIES",
      details:
          "There are three weapon types / abilities available. "
          "Single/Burst switch, Stun neutralizebutton and Scanner button. "
          "They counter different cyber attacks each wave.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final carouselItems = tutorialData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;

      return HowToPlayVideoItem(data: data, isActive: _currentIndex == index);
    }).toList();

    final dynamicText = Padding(
      padding: const .symmetric(horizontal: 32.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Column(
          key: ValueKey<int>(_currentIndex),
          children: [
            Text(
              tutorialData[_currentIndex].title,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: .bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tutorialData[_currentIndex].details,
              textAlign: .center,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 16),
            const Text(
              "(Tap the highlighted video to play/pause)",
              style: TextStyle(fontSize: 12, color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );

    final carouselSlider = CarouselSlider(
      options: CarouselOptions(
        height: frameHeight,
        autoPlay: false,
        enlargeCenterPage: true,
        viewportFraction: 0.5,
        onPageChanged: (index, reason) {
          setState(() => _currentIndex = index);
        },
      ),
      items: carouselItems,
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
