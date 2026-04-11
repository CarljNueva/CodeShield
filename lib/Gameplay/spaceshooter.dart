import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame/experimental.dart';
import 'package:codeshield/gameplay/player.dart';
import 'package:codeshield/gameplay/enemy.dart';
import 'package:codeshield/gameplay/home_base.dart';
import 'package:codeshield/gameplay/scorehud.dart';
import 'dart:math'; // 1. Added for Random selection
import 'package:codeshield/gameplay/enemy_database.dart'; // Ensure this is imported

class SpaceShooterGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  late Player player;
  late HomeBase homebase;

  int basehealth = 100;
  int score = 0; // The global score variable
  late ScoreBoard _scoreBoard;
  late HomeBaseHealth _baseHealth;

  Color bulletColor = Colors.white; // bullet configuration
  final List<Color> colorOptions = [
    Colors.white,
    Colors.greenAccent,
    Colors.redAccent,
    Colors.blueAccent,
  ];
  int colorIndex = 0;

  @override
  Future<void>? onLoad() async {
    final parallax = await loadParallaxComponent(
      [ParallaxImageData('Background.png')],
      baseVelocity: Vector2(20, -5),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(1.5, 0),
    );
    add(parallax); // Adding Background to Game

    homebase = HomeBase(); // Adding the Homebase Server
    add(homebase);

    _scoreBoard = ScoreBoard(); // Adding Scoreboard to Interface
    add(_scoreBoard);

    _baseHealth = HomeBaseHealth(); // Health interface
    add(_baseHealth);

    player = Player();
    add(player); // Adding Player to interface

    add(
      SpawnComponent(
        period: 1.0,
        factory: (index) {
          // 2. Pick a random enemy type from your registry
          final types = enemyRegistry.keys.toList();
          final randomType = types[Random().nextInt(types.length)];
          final config = enemyRegistry[randomType]!;

          // 3. Return the Enemy with its specific data
          return Enemy(config: config, type: randomType);
        },
        // Keep your area logic as is
        area: Rectangle.fromRect(
          Rect.fromLTWH(size.x + 200, 50, 100, size.y - 100),
        ),
      ),
    );

    add(
      //temporary button change button
      SpriteButtonComponent(
        button: await loadSprite('switch_icon.png'), // Replace with your icon
        buttonDown: await loadSprite('switch_icon.png'),
        position: Vector2(canvasSize.x - 80, canvasSize.y - 80), // Bottom Right
        size: Vector2(64, 64),
        onPressed: () {
          colorIndex = (colorIndex + 1) % colorOptions.length;
          bulletColor = colorOptions[colorIndex];
        },
      ),
    );
  }

  //Input Handling
  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.global);
  }

  @override
  void onPanStart(DragStartInfo info) {
    player.startShooting();
  }

  @override
  void onPanEnd(DragEndInfo info) {
    player.stopShooting();
  }
}
