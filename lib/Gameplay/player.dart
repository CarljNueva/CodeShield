
import 'package:flame/components.dart';
import 'package:codeshield/Gameplay/spaceshooter.dart';
import 'package:codeshield/Gameplay/bullet.dart';

class Player extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame> {
  late final SpawnComponent _bulletSpawner;

  Player() : super(size: Vector2(92.5, 80), angle: 1.57, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'Gray1.png',
      SpriteAnimationData.sequenced(
        amount: 5,
        stepTime: 0.1,
        textureSize: Vector2(
          19,
          20,
        ), //isaac pls remember this is the perfect dimension for seamless animation for ship
      ),
    );

    position = game.size / 2;

    _bulletSpawner = SpawnComponent(
      period: .2,
      selfPositioning: true,
      factory: (index) {
        return Bullet(position: position.clone() + Vector2(size.x / 1.5, 2));
      },
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