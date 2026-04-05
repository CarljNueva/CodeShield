
import 'package:codeshield/Gameplay/Weapons/honeypotdecoy.dart';
import 'package:codeshield/Gameplay/Weapons/powerup.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:codeshield/Gameplay/home_base.dart';
import 'package:codeshield/Gameplay/spaceshooter.dart';
import 'package:codeshield/Gameplay/Weapons/bullet.dart';
import 'package:codeshield/Gameplay/explosion.dart';
import 'package:codeshield/Gameplay/EnemyConfig/enemy_database.dart'; // Ensure this is imported
import 'package:codeshield/Gameplay/Weapons/scan_wave.dart';
import 'dart:math';

import 'package:flutter/material.dart'; 

class EnemyConfig {
  final String spritePath;
  final double speed;
  final double health;
  final Vector2 textureSize;
  final int frames;      // Number of frames in the sprite sheet
  final double stepTime; // How fast the animation plays

  EnemyConfig({
    required this.spritePath,
    required this.textureSize,
    this.speed = 150,
    this.health = 1,
    this.frames = 1,      // Default to 1 for static images // useless
    this.stepTime = 0.5,  // Default animation speed
  });
}

class Enemy extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  
  final EnemyConfig config;
  final EnemyType type;
  late double health;
  bool isRevealed = false;
  bool isMalicious = true; // Track if the revealed email is actually bad

  bool isStunned = false;
  double stunTimer = 0;
  bool hasShield = true; 

  bool isReplicant = false;

  Enemy({required this.config, required this.type, super.position})
    : super(size: Vector2.all(80.0), anchor: Anchor.center) {
      health = config.health;
    }

  void reveal() async {
    if (isRevealed) return; 
    isRevealed = true;
    final random = Random();

    // --- LOGIC FOR TROJANS ---
    if (type == EnemyType.trojan) {

      animation = await game.loadSpriteAnimation(
        'Trojan.png',
        SpriteAnimationData.sequenced(
          amount: 1, 
          stepTime: .2,
          textureSize: Vector2(128, 128), 
        ),
      );
      isMalicious = true; 
    } 
    
    // --- LOGIC FOR PHISHING (50/50 chance Safe vs Danger) ---
    else if (type == EnemyType.phishing) {
      bool chance = random.nextBool(); // True = Danger, False = Safe

      if (chance) {
        isMalicious = true;
        animation = await game.loadSpriteAnimation(
          'email_danger.png',
          SpriteAnimationData.sequenced(
            amount: 6, 
            stepTime: 0.15,
            textureSize: Vector2(128, 128),
          ),
        );
      } else {
        isMalicious = false;
        animation = await game.loadSpriteAnimation(
          'email_safe.png',
          SpriteAnimationData.sequenced(
            amount: 6, 
            stepTime: 0.15,
            textureSize: Vector2(128, 128),
          ),
        );
      }
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    String spriteToLoad = config.spritePath;
    var loop = true;
    if(type == EnemyType.trojan){
      randomTrojan = trojanSprites[random.nextInt(trojanSprites.length)];
      spriteToLoad = randomTrojan; 
      addNewSprite(spriteToLoad,loop);
    } else if(type == EnemyType.antivirus){
      randomAntivirus = antivirusSprites[random.nextInt(antivirusSprites.length)];
      spriteToLoad = randomAntivirus; 
      addNewSprite(spriteToLoad,loop);

    } else if(type == EnemyType.malware){
      randomVirus = virusSprites[random.nextInt(virusSprites.length)];
      spriteToLoad = randomVirus;
      addNewSprite(spriteToLoad,loop);

    } else if (type == EnemyType.ransomware){
      animationTicker?.currentIndex = 1;
      hasShield = true;
      loop = false;
      addNewSprite(spriteToLoad,loop);
    } else{
  
    addNewSprite(spriteToLoad,loop);}
  }
 // problem email needs to also access addNewSprite
  Future<void> addNewSprite(String spritepath, state ) async {
    double finalStepTime = (type == EnemyType.ransomware) 
      ? double.infinity 
      : config.stepTime;

    animation = await game.loadSpriteAnimation(
      spritepath,
      SpriteAnimationData.sequenced(
        amount: config.frames,
        stepTime: finalStepTime,
        textureSize: config.textureSize,
        loop: state, 
      ),
    );

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    if (type == EnemyType.ransomware && hasShield) {
    animationTicker?.currentIndex = 1;
    final decoy = game.children.whereType<HoneyPotDecoy>().firstOrNull;

    if (decoy != null) {
    // LURE: Move toward the decoy's position instead of the base
    Vector2 direction = (decoy.position - position).normalized();
    position += direction * config.speed * dt;
  } else {
    // NORMAL: Move left toward the HomeBase
    position.x -= dt * config.speed;
  }

    }

    if (isStunned) {
      stunTimer -= dt;
      if (stunTimer <= 0) {
        isStunned = false;
        paint.colorFilter = null; // Remove the "yellow" stun look
      }
      return; // Stop movement while stunned
    }
    super.update(dt);
    // Use the config.speed instead of a hardcoded number
    position.x -= dt * config.speed;

    if (position.x < -width) {
      removeFromParent();
    }
  }

  void applyStun() {
    isStunned = true;
    stunTimer = 2.0; // 1 second freeze
    paint.colorFilter = const ColorFilter.mode(Colors.yellow, BlendMode.srcATop);

    // SPECIAL INTERACTION: Ransomware Shield Break
    if (type == EnemyType.ransomware && hasShield) {
      hasShield = false;
      animationTicker?.currentIndex = 0;
    }
  }

   @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    onRemove();

    if (other is ScanWave) {
      reveal();
      return;
    }

    if (other is Bullet) {
      // Penalty for shooting a revealed SAFE emai

      if (isRevealed && type == EnemyType.phishing && !isMalicious) {
        game.score -= 50; 
      } else if (type == EnemyType.ransomware && hasShield) {
      // The bullet hits the "Encryption Shield" and does nothing
      other.removeFromParent(); 
      // Optional: Add a 'ting' sound or a small spark effect here
      return; 
    }
      
      health--; 
      other.removeFromParent();

      if (health <= 0) {
        removeFromParent();
        game.add(Explosion(position: position));
        game.score += (isRevealed && isMalicious) ? 100 : 10;
      }
    } 
    
    else if (other is HomeBase) {
      removeFromParent();
      
      if (other.isShieldActive) {
      // MFA blocked the threat!
      removeFromParent();
      game.add(Explosion(position: position));
      return; // No damage to basehealth
    }
      // If it's revealed as SAFE, it heals the base.
      // If it's NOT revealed, it acts as a threat (player failed to scan).
      if (isRevealed && !isMalicious || type == EnemyType.antivirus) {
        game.basehealth = (game.basehealth + 10).clamp(0, 100);
        game.score += 50; // Bonus for letting safe data through
      } else {
        game.basehealth -= 10;
        game.add(Explosion(position: position));
      }
      
      game.healthBar.updateHealth(game.basehealth);
      other.triggerHitEffect();
    }

    
  }

@override
void onRemove() {
  super.onRemove();

  if (game.waveManager.random.nextDouble() < 0.20 && health <= 0) {
    _dropPowerUp();
  }

  // If a Malware enemy dies, it "replicates" into 2 smaller/faster versions
  if (type == EnemyType.malware && health <= 0) {
    _replicate();
    
  }
}

void _dropPowerUp() {
  final types = PowerUpType.values;
  final randomType = types[game.waveManager.random.nextInt(types.length)];
  game.add(PowerUp(type: randomType, position: position.clone()));
}

void _replicate() {
    // If this is already a child/replicant, STOP the chain here
    if (isReplicant) return;

    for (int i = 0; i < 2; i++) {
      double yOffset = (i == 0) ? -40 : 40;
      
      final newMalware = Enemy(
        config: config,
        type: type,
        position: position + Vector2(10, yOffset), 
      );

      // Mark the new ones so they DON'T split again
      newMalware.isReplicant = true; 
      newMalware.health = 1; // Make them easy to clear
      
      // Optional: Make replicants faster to simulate a "spreading" virus
      // newMalware.config.speed += 50; 

      game.add(newMalware);
    }
  }
}