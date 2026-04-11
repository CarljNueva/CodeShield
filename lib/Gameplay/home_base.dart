import 'package:flame/components.dart';
import 'package:flame/collisions.dart'; // Required for RectangleHitbox
import 'package:flutter/material.dart'; // Required for Colors/Paint
import 'package:codeshield/gameplay/spaceshooter.dart';

// HomeBase file

class HomeBase extends RectangleComponent
    with HasGameReference<SpaceShooterGame> {
  late SpriteComponent
  _visual; // This must be assigned! // If modifying Homebase must use _visual

  HomeBase()
    : super(
        size: Vector2(256, 1080),
        position: Vector2(0, -175),
        paint: Paint()..color = Colors.transparent,
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. Assign the component to the _visual variable
    _visual = SpriteComponent(
      sprite: await game.loadSprite("home_server.png"),
      size: size,
    );

    // 2. Add it as a child
    add(_visual);

    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  void triggerHitEffect() {
    // Now _visual actually exists and has a paint property
    _visual.paint.colorFilter = const ColorFilter.mode(
      Colors.red,
      BlendMode.srcATop,
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      // Safely check if the component is still mounted before resetting
      if (_visual.isMounted) {
        _visual.paint.colorFilter = null;
      }
    });
  }
}
