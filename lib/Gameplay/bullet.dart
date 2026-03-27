import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:codeshield/Gameplay/spaceshooter.dart';



class Bullet extends RectangleComponent with HasGameReference<SpaceShooterGame> {
  Bullet({super.position})
      : super(
          size: Vector2(40, 8),
          anchor: Anchor.center,
          priority: 10,
          // Pull the color from the game state
          paint: Paint(), 
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Apply the current game bullet color to this specific bullet
    paint.color = game.bulletColor;

    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x += dt * 500;
    if (position.x > game.size.x + width) {
      removeFromParent();
    }
  }
}