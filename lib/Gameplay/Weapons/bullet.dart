import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:codeshield/Gameplay/spaceshooter.dart';



class Bullet extends RectangleComponent with HasGameReference<SpaceShooterGame> {
  // Add a velocity variable
  final Vector2 velocity;

  // Update constructor to accept velocity (defaulting to straight right)
  Bullet({required Vector2 position, Vector2? velocity})
      : velocity = velocity ?? Vector2(600, 0),
        super(
          position: position,
          size: Vector2(40, 8),
          anchor: Anchor.center,
          priority: 10,
          paint: Paint(),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    paint.color = game.bulletColor;
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Move using the specific velocity
    position.add(velocity * dt);
    
    // Cleanup if offscreen
    if (position.x > game.size.x + width || position.y < 0 || position.y > game.size.y) {
      removeFromParent();
    }
  }
}