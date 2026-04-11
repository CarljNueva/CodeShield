import 'dart:math';
import 'package:flame/components.dart';
import 'package:codeshield/gameplay/spaceshooter.dart';
import 'package:codeshield/gameplay/enemy_config/enemy_database.dart';
import 'package:codeshield/gameplay/enemy_config/boss.dart';

class WaveManager extends Component with HasGameReference<SpaceShooterGame> {
  int currentWaveNumber = 1;
  double waveTimer = 120; // 2 minutes (modify for testing)
  double spawnTimer = 0;
  double spawnInterval = 1.0; // Seconds between enemy spawns

  OSILayer? currentLayer;
  final Random random = Random();

  bool bossSpawned = false;

  late SpriteAnimation animation;

  @override
  void onMount() {
    super.onMount();
    _startNewWave();
  }

  void _startNewWave() {
    waveTimer = 120.0;
    bossSpawned = false;

    if (currentWaveNumber % 5 == 0) {
      currentLayer = OSILayer.boss;
    } else {
      List<OSILayer> layers = [
        OSILayer.layer6,
        OSILayer.layer7,
        OSILayer.layer3,
        OSILayer.layer4,
        OSILayer.layer5,
      ];
      currentLayer = layers[random.nextInt(layers.length)];
    }

    // Create a clean name for the display
    String layerName = "";
    switch (currentLayer) {
      case OSILayer.layer3:
        layerName = "Layer 3: Network";
        break;
      case OSILayer.layer4:
        layerName = "Layer 4: Transport";
        break;
      case OSILayer.layer5:
        layerName = "Layer 5: Session";
        break;
      case OSILayer.layer6:
        layerName = "Layer 6: Presentation";
        break;
      case OSILayer.layer7:
        layerName = "Layer 7: Application";
        break;
      case OSILayer.boss:
        layerName = " !!! MULTI-LAYER ATTACK: BOSS!!!";
        break;
      default:
        layerName = "Unknown Layer";
    }

    String fullMessage = "WAVE $currentWaveNumber $layerName";

    // This will now find waveUI because we changed the order in spaceshooter.dart
    game.showWaveAnnouncement(fullMessage);
  }

  @override
  void update(double dt) {
    waveTimer -= dt;
    spawnTimer += dt;

    if (waveTimer <= 0) {
      currentWaveNumber++;
      _startNewWave();
    }

    if (spawnTimer >= spawnInterval) {
      spawnTimer = 0;
      _spawnEnemy();
    }
  }

  Future<void> _spawnEnemy() async {
    if (currentLayer == null) return;

    EnemyType typeToSpawn;

    if (currentLayer == OSILayer.boss && !bossSpawned) {
      // In boss wave, spawn any variety of enemy
      _spawnBoss();
      bossSpawned = true;
      spawnInterval = 5.0; // Spawns every 5 seconds instead of 2
      List<EnemyType> allTypes = EnemyType.values
          .where((t) => t != EnemyType.trojan)
          .toList();
      typeToSpawn = allTypes[random.nextInt(allTypes.length)];
    } else {
      // Spawn only from the current OSI layer
      spawnInterval = 2.0;
      List<EnemyType>? possibleEnemies = layerEnemies[currentLayer];
      typeToSpawn = possibleEnemies![random.nextInt(possibleEnemies.length)];
    }

    if (random.nextDouble() < 0.20 && currentLayer != OSILayer.boss) {
      spawnPattern(currentLayer!);

      // We "penalize" the timer so the screen doesn't get
      // flooded immediately after a big pattern spawn
      spawnTimer = -2.0;
    } else {
      // Normal single spawn
      game.spawnEnemy(typeToSpawn);
    }
  }

  void _spawnBoss() {
    game.add(BossFight(position: Vector2(game.size.x + 200, game.size.y / 2)));
  }

  void spawnPattern(OSILayer layer) {
    List<EnemyType>? possible = layerEnemies[layer];
    if (possible == null) return;

    final type = possible[random.nextInt(possible.length)];
    int patternType = random.nextInt(3);

    switch (patternType) {
      case 0:
        _spawnTriangle(type);
        break;
      case 1:
        _spawnVerticalLine(type);
        break;
      case 2:
        _spawnArrow(type);
        break;
    }
  }

  void _spawnTriangle(EnemyType type) {
    final startX = game.size.x + 100;
    final centerY = game.size.y / 2;

    // 3 enemies in a triangle
    game.spawnEnemyAt(type, Vector2(startX, centerY)); // Tip
    game.spawnEnemyAt(type, Vector2(startX + 60, centerY - 60)); // Top Back
    game.spawnEnemyAt(type, Vector2(startX + 60, centerY + 60)); // Bottom Back
  }

  void _spawnVerticalLine(EnemyType type) {
    final startX = game.size.x + 100;
    // Spawn 4 enemies in a vertical column
    for (int i = 1; i <= 4; i++) {
      game.spawnEnemyAt(type, Vector2(startX, (game.size.y / 5) * i));
    }
  }

  void _spawnArrow(EnemyType type) {
    final startX = game.size.x + 100;
    final midY = game.size.y / 2;
    // 5 enemies forming a > shape
    game.spawnEnemyAt(type, Vector2(startX, midY));
    game.spawnEnemyAt(type, Vector2(startX + 40, midY - 40));
    game.spawnEnemyAt(type, Vector2(startX + 40, midY + 40));
    game.spawnEnemyAt(type, Vector2(startX + 80, midY - 80));
    game.spawnEnemyAt(type, Vector2(startX + 80, midY + 80));
  }
}
