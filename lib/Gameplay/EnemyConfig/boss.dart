import 'dart:async';
import 'package:codeshield/Gameplay/home_base.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:codeshield/Gameplay/spaceshooter.dart';
import 'package:codeshield/Gameplay/EnemyConfig/enemy_database.dart';
import 'package:codeshield/Gameplay/Weapons/bullet.dart';
import 'package:codeshield/Gameplay/explosion.dart';

class BossHealthBar extends PositionComponent with HasGameReference<SpaceShooterGame> {
  @override
  void render(Canvas canvas) {
    final parent = this.parent as BossFight;
    final percent = parent.health / parent.maxHealth;
    
    // Background (Red)
    canvas.drawRect(Rect.fromLTWH(0, -20, 100, 10), Paint()..color = Colors.red);
    // Foreground (Green)
    canvas.drawRect(Rect.fromLTWH(0, -20, 100 * percent, 10), Paint()..color = Colors.green);
  }
}

class BossFight extends SpriteAnimationComponent with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  double health = 500; // Boss has much more health
  double maxHealth = 500;
  double spawnTimer = 0;
  bool isMouthOpen = false;
  int lastSpawnIndex = -1;

  BossFight({required Vector2 position}) : super(
    position: position,
    size: Vector2(512, 512), // Adjust based on your preference
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'theisaac.png',
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: double.infinity, // We control frames manually
        textureSize: Vector2(512, 512), // Match your enemyRegistry entry
      ),
    );

    add(RectangleHitbox(size: size * 0.50, // Shrink the box to 70% of the 250x250 size
      position: size * 0.15, // Offset it by 15% to keep it centered
    ));
    
    // Add the health bar as a child so it moves WITH the boss
    add(BossHealthBar());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 1. Slow Movement (Drifts left slowly)
    position.x -= 20 * dt;

    // 2. Spawning Logic
    spawnTimer += dt;

    // Every 3 seconds, open mouth for 2 seconds
    if (!isMouthOpen && spawnTimer >= 3.0) {
      _openMouth();
    } else if (isMouthOpen && spawnTimer >= 5.0) {
      _closeMouth();
    }
  }

  Future<void> _openMouth() async {
  isMouthOpen = true;
  spawnTimer = 1;
  animationTicker?.currentIndex = 1; // Open mouth frame
  final enemyPosition = position.clone();
  enemyPosition.y += 85;

  // Spawn 2 enemies with a slight delay so they form a line
    for (int i = 0; i < 2; i++) {
      int nextIndex = game.waveManager.random.nextInt(5);
      EnemyType typeToSpawn = EnemyType.values[nextIndex];

      // Spawn exactly at the mouth
      game.spawnEnemyAt(typeToSpawn, enemyPosition);

      // Wait a split second before spawning the next one
      await Future.delayed(const Duration(milliseconds: 600));
      
      // Check if boss was killed during the delay to prevent errors
      if (!isMounted) return; 
    }

}

  void _closeMouth() {
    isMouthOpen = false;
    spawnTimer = 0;
    animationTicker?.currentIndex = 0; // Mouth Closed Frame
  }

  void triggerHitEffect() {
    paint.colorFilter = const ColorFilter.mode(Colors.red, BlendMode.srcATop);
    Future.delayed(const Duration(milliseconds: 100), () {
      paint.colorFilter = null;
    });
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bullet) {
      health -= 10;
      triggerHitEffect();
      other.removeFromParent();

      if (health <= 0) {
        removeFromParent();
        game.score += 1000; // Big boss reward
        // Optional: Trigger next wave immediately
      } 
    } else if (other is HomeBase){
        removeFromParent();
        game.basehealth -= 100;
        game.healthBar.updateHealth(game.basehealth);
        game.add(Explosion(position: position));
        other.triggerHitEffect;
      }
  }
}