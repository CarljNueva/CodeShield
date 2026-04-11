import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:codeshield/gameplay/home_base.dart';
import 'package:codeshield/gameplay/spaceshooter.dart';
import 'package:codeshield/gameplay/bullet.dart';
import 'package:codeshield/gameplay/explosion.dart';

enum EnemyType { botnet, ransomware, phishing, malware }

class EnemyConfig {
  final String spritePath;
  final double speed;
  final double health;
  final Vector2 textureSize;
  final int animationFrames;

  EnemyConfig({
    required this.spritePath,
    this.speed = 150,
    this.health = 1,
    required this.textureSize,
    this.animationFrames = 1,
  });
}

class Enemy extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  // 1. Add these variables to store the data from the database
  final EnemyConfig config;
  final EnemyType type;
  late double health;

  // 2. Update the constructor to accept the data
  Enemy({required this.config, required this.type, super.position})
    : super(size: Vector2.all(enemySize), anchor: Anchor.center) {
    health = config.health; // Initialize health from the config
  }

  static const enemySize = 50.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 3. Use the config values for the animation
    animation = await game.loadSpriteAnimation(
      config.spritePath,
      SpriteAnimationData.sequenced(
        amount: config.animationFrames,
        stepTime: .2,
        textureSize: config.textureSize,
      ),
    );

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 4. Use the config.speed instead of a hardcoded number
    position.x -= dt * config.speed;

    if (position.x < -width) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet) {
      // 5. Handle multi-hit enemies (like Ransomware)
      health--;
      other.removeFromParent();

      if (health <= 0) {
        removeFromParent();
        game.add(Explosion(position: position));
        game.score += 10;
      }
    } else if (other is HomeBase) {
      removeFromParent();
      game.add(Explosion(position: position));
      other.triggerHitEffect();
      game.basehealth -= 10;
    }
  }
}
