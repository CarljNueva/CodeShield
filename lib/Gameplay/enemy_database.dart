import 'package:codeshield/Gameplay/enemy.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/game.dart';

final Map<EnemyType, EnemyConfig> enemyRegistry = {
  EnemyType.phishing: EnemyConfig(
    spritePath: 'SampleEmailEnemy.png',
    speed: 200,
    textureSize: Vector2(256, 256),
  ),
  EnemyType.ransomware: EnemyConfig(
    spritePath: 'LargeAlienSpide0.png',
    speed: 80,
    health: 3, // Needs more hits
    textureSize: Vector2(1180, 800),
  ),
  // Add Phishing, Malware, etc. here easily!
};