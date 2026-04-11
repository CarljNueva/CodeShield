import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:codeshield/gameplay/spaceshooter.dart';

class ScoreBoard extends TextComponent with HasGameReference<SpaceShooterGame> {
  ScoreBoard()
    : super(
        text: 'Data Protected: 0',
        position: Vector2(40, 40), // Top left corner
        anchor: Anchor.topLeft,
        priority: 100, // Ensure it's above everything else
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Orbitron', // Use a techy font if you have one!
          ),
        ),
      );

  @override
  void update(double dt) {
    // Automatically update the text based on the game's score variable
    text = 'Data Protected: ${game.score}';
    super.update(dt);
  }
}

class HomeBaseHealth extends TextComponent
    with HasGameReference<SpaceShooterGame> {
  HomeBaseHealth()
    : super(
        text: 'BASE HEALTH: 100',
        position: Vector2(20, 20), // Top left corner
        anchor: Anchor.topLeft,
        priority: 100, // Ensure it's above everything else
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Orbitron', // Use a techy font if you have one!
          ),
        ),
      );

  @override
  void update(double dt) {
    // Automatically update the text based on the game's score variable
    text = 'BASE HEALTH: ${game.basehealth}';
    super.update(dt);
  }
}
