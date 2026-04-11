import 'package:codeshield/gameplay/weapons/honeypotdecoy.dart';
import 'package:codeshield/gameplay/explosion.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:codeshield/gameplay/player.dart';
import 'package:codeshield/gameplay/enemy_config/enemy.dart';
import 'package:codeshield/gameplay/home_base.dart';
import 'package:codeshield/gameplay/scorehud.dart';
import 'dart:math';
import 'package:codeshield/gameplay/enemy_config/enemy_database.dart';
import 'package:codeshield/gameplay/weapons/scan_wave.dart';
import 'package:codeshield/gameplay/health_bar.dart';
import 'package:codeshield/gameplay/wave_manager.dart';
import 'package:codeshield/gameplay/wave_announcement.dart';
import 'package:codeshield/gameplay/powerup.dart';

enum WeaponType { standard, shotgun, stun }

class SpaceShooterGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  late Player player;
  WeaponType currentWeapon = WeaponType.standard;
  late SpriteButtonComponent shotgunToggle;
  late HomeBase homebase;
  late WaveManager waveManager;

  int basehealth = 100;
  int score = 0; // The global score variable
  late ScoreBoard _scoreBoard;
  late HomeBaseHealth _baseHealth;
  late HealthBar healthBar;
  late TextComponent waveUI;

  Color bulletColor = Colors.white;
  int colorIndex = 0;
  final _random = Random();

  @override
  Future<void>? onLoad() async {
    final parallax = await loadParallaxComponent(
      [ParallaxImageData('Background.png')],
      baseVelocity: Vector2(20, -5),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(1.5, 0),
    );
    add(parallax); // Adding Background to Game

    debugMode = false;
    add(FpsTextComponent(position: Vector2(10, 10), anchor: Anchor.topLeft));

    homebase = HomeBase(); // Adding the Homebase Server
    add(homebase);

    healthBar = HealthBar();
    add(healthBar);

    _scoreBoard = ScoreBoard(); // Adding Scoreboard to Interface
    add(_scoreBoard);

    healthBar = HealthBar();
    add(healthBar);

    _baseHealth = HomeBaseHealth(); // Health interface
    add(_baseHealth);

    player = Player();
    add(player); // Adding Player to interface

    waveUI = TextComponent(
      text: 'OSI Layer: Initialize...',
      position: Vector2(size.x / 2, 20),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
    add(waveUI);

    waveManager = WaveManager();
    add(waveManager);

    add(
      SpriteButtonComponent(
        button: await loadSprite('stun_unpressed.png'),
        buttonDown: await loadSprite('stun_pressed.png'),
        position: Vector2(
          canvasSize.x - 320,
          canvasSize.y - 180,
        ), // Next to the other button
        size: Vector2(128, 128),
        onPressed: () {
          player.fireStunAbility();
        },
      ),
    );

    add(
      SpriteButtonComponent(
        button: await loadSprite('scanner_unpressed.png'),
        buttonDown: await loadSprite('scanner_pressed.png'),
        position: Vector2(canvasSize.x - 180, canvasSize.y - 180),
        size: Vector2(128, 128),
        onPressed: () {
          add(ScanWave(position: Vector2(player.position.x, 0)));
          add(
            ScanWave(position: Vector2(player.position.x - 20, 0))
              ..paint.color = Colors.cyan.withValues(alpha: 0.3),
          );
        },
      ),
    );

    shotgunToggle = SpriteButtonComponent(
      button: await loadSprite('shotgun_unpressed.png'),
      buttonDown: await loadSprite('shotgun_pressed.png'),
      position: Vector2(canvasSize.x - 460, canvasSize.y - 180),
      size: Vector2(128, 128),
      onPressed: () async {
        if (currentWeapon == WeaponType.standard) {
          // Switch to SHOTGUN
          currentWeapon = WeaponType.shotgun;
          player.updateFireRate(0.6); // Slower, powerful blast

          // Change the button look to show it's "Active" or a "Back" icon
          shotgunToggle.button = await loadSprite('single_shot_unpressed.png');
          shotgunToggle.buttonDown = await loadSprite(
            'single_shot_pressed.png',
          );
        } else {
          // Switch back to STANDARD
          currentWeapon = WeaponType.standard;
          player.updateFireRate(0.2); // Faster single shots

          // Revert the button look
          shotgunToggle.button = await loadSprite('shotgun_unpressed.png');
          shotgunToggle.buttonDown = await loadSprite('shotgun_pressed.png');
        }
      },
    );

    add(shotgunToggle);
  }

  void showWaveAnnouncement(String message) {
    // 1. Update the permanent UI
    waveUI.text = message;

    // 2. Spawn the big fading text
    add(WaveAnnouncement(text: message));
  }

  //Input Handling
  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.global);
  }

  @override
  void onPanStart(DragStartInfo info) {
    player.startShooting();
  }

  @override
  void onPanEnd(DragEndInfo info) {
    player.stopShooting();
  }

  void spawnEnemy(EnemyType type) {
    final config = enemyRegistry[type];
    if (config != null) {
      add(
        Enemy(
          config: config,
          type: type,
          position: Vector2(size.x + 50, _random.nextDouble() * size.y),
        ),
      );
    }
  }

  void spawnEnemyAt(EnemyType type, Vector2 spawnPos) {
    final config = enemyRegistry[type];
    if (config != null) {
      add(
        Enemy(
          config: config,
          type: type,
          position: spawnPos, // Spawns where the boss is!
        ),
      );
    }
  }

  void applyPowerUp(PowerUpType type) {
    switch (type) {
      case PowerUpType.fireRate:
        // Boost: 0.05s is super fast machine gun mode
        player.updateFireRate(0.05);
        // Revert after 5 seconds
        Future.delayed(const Duration(seconds: 5), () {
          player.updateFireRate(0.2);
        });
        break;

      case PowerUpType.totalReset:
        // Remove all enemies currently on screen
        children.whereType<Enemy>().forEach((e) => e.removeFromParent());
        add(
          Explosion(position: size / 2)..scale = Vector2.all(10),
        ); // Massive flash
        break;

      case PowerUpType.firewall:
        // Push logic: Move all enemies back to the right
        children.whereType<Enemy>().forEach((e) {
          e.position.x = size.x + 100;
        });
        break;

      case PowerUpType.honeyPot:
        // Spawn a decoy at the center
        add(HoneyPotDecoy(position: size / 2));
        break;

      case PowerUpType.mfaShield:
        homebase.activateMFAShield();
        break;
    }
  }
}
