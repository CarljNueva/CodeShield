
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:codeshield/Gameplay/spaceshooter.dart';
import 'package:codeshield/Gameplay/Weapons/bullet.dart';
import 'package:codeshield/Gameplay/Weapons/stun_round.dart';

class Player extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame> {
  late final SpawnComponent _bulletSpawner;

  Player() : super(size: Vector2(128, 128), anchor: Anchor.center);

  double stunCooldown = 0;
  final double stunMaxCooldown = 2.0;

  @override
  void update(double dt) {
    super.update(dt);
    // Count down the cooldown timer
    if (stunCooldown > 0) {
      stunCooldown -= dt;
    }
  }

  void fireStunAbility() {
    // Only fire if the cooldown is finished
    if (stunCooldown <= 0) {
      final spawnPos = position.clone() + Vector2(size.x / 1.5, 2);
      game.add(StunRound(position: spawnPos));
            // Reset cooldown
      stunCooldown = stunMaxCooldown;
  }
}
  // Inside your Player class
  void updateFireRate(double newPeriod) {
    _bulletSpawner.period = newPeriod;
  }

void _fireWeapon() {
  final spawnPos = position.clone() + Vector2(size.x / 1.5, 2);

    if (game.currentWeapon == WeaponType.stun){
      game.add(StunRound(position: spawnPos));
    }
    else if (game.currentWeapon == WeaponType.shotgun) {
    // Fire 5 pellets in a "V" shape
    for (int i = 0; i < 5; i++) {
      // This math spreads the bullets vertically: -200, -100, 0, 100, 200
      double ySpread = (i - 2) * 100; 
      
      game.add(Bullet(
        position: spawnPos,
        velocity: Vector2(600, ySpread), // 600 is forward speed
      ));
    }
  } else {
    // Single standard bullet
    game.add(Bullet(
      position: spawnPos,
      velocity: Vector2(700, 0),
    ));
  }
}
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    
    
    animation = await game.loadSpriteAnimation(
      'playerplayer.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: Vector2(
          256,
          256,
        ), 
      ),
    );

    add(RectangleHitbox());
    
    position = game.size / 2;

    _bulletSpawner = SpawnComponent(
    period: .2, // Standard fire rate
    factory: (index) {
      _fireWeapon(); // Call our helper function
      return PositionComponent(); // Return a "dummy" that doesn't show up
    },
    selfPositioning: true,
    autoStart: false,
  );

  game.add(_bulletSpawner);
  }

  void startShooting() {
    _bulletSpawner.timer.start();
  }

  void stopShooting() {
    _bulletSpawner.timer.stop();
  }

  void move(Vector2 delta) {
    position.add(delta);
  }
}
    