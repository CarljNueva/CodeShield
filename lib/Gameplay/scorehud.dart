import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:codeshield/Gameplay/spaceshooter.dart';

class ScoreBoard extends TextComponent with HasGameReference<SpaceShooterGame> {
  ScoreBoard()
      : super(
          text: 'Data Protected: 0',
          position: Vector2(1250, 40), // Top left corner
          anchor: Anchor.topLeft,
          priority: 100, // Ensure it's above everything else
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              fontFamily: 'PixelifySans', // Use a techy font if you have one!
            ),
          ),
        );

  @override
  void update(double dt) {
    // Automatically update the text based on the game's score variable
    text = 'SCORE: ${game.score}';
    super.update(dt);
  }
}

class HomeBaseHealth extends TextComponent with HasGameReference<SpaceShooterGame> {
  HomeBaseHealth()
      : super(
          text: 'HEALTH: 100',
          position: Vector2(650, 50), // Top left corner
          anchor: Anchor.topLeft,
          priority: 100, // Ensure it's above everything else
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'PixelifySans', // Use a techy font if you have one!
            ),
          ),
        );

  @override
  void update(double dt) {
    // Automatically update the text based on the game's score variable
    text = 'BASE HEALTH: ${game.basehealth} / 100';
    super.update(dt);
  }
}