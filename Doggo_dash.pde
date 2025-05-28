// === Constants ===
final int WORLD_VIEW_COLUMNS = 22;
final int WORLD_MAX_TILE_HEIGHT = 20;
final int TILE_SIZE = 80;

final int TILE_AIR = 0;
final int TILE_GROUND = 1;
final int TILE_SPIKE_PLACEHOLDER = 2;       // Obstacle1 (spikes)
final int TILE_OBSTACLE2_PLACEHOLDER = 4;   // Obstacle2 (green blocks)

final int TILE_POWERUP_DOUBLE_POINTS = 6;
final int TILE_POWERUP_SLOMO = 7;
final int TILE_POWERUP_INVINCIBLE = 8;

// === RWG State Variables ===
boolean rwgCanChangeElevation = true;
boolean rwgCanAddObstacle = true;
boolean rwgCurrentlyAddingFeature = false;

int rwgCurrentElevation = 3;
int rwgPostFeatureTimer = 0;
int rwgFeatureDurationCounter = 0;
int rwgRavineDepth = 0;
int rwgActiveFeatureTileType = TILE_AIR;

// === Gameplay variables ===
float worldScrollPixelOffset = 0;
float baseGameSpeed = 4.0f;
float currentGameSpeed = baseGameSpeed;

final float PLAYER_SPRITE_WIDTH = 50;
PImage imgPlayer;

ArrayList<ArrayList<Integer>> worldTileData;
ArrayList<ObstacleBase> gameObstacles;
ArrayList<powerUpsBase> activePowerUpsList;
Player player;

int gameState;
final int STATE_GAME_RUN = 2;
final int STATE_GAME_OVER = 3;

long score = 0;
int scoreFrameCounter = 0;
int scorePointValue = 1;

int activePowerUpType = 0;
int powerUpEffectTimer = 0;

// --- Setup ---
void setup() {
  size(1600, 900);

  worldTileData = new ArrayList<ArrayList<Integer>>();
  initializeEmptyAirForRWG();

  imgPlayer = loadImage("sahur.jpg");
  if (imgPlayer == null) {
    println("Player image 'sahur.jpg' not found in data folder.");
    exit();
  }
  imgPlayer.resize((int)PLAYER_SPRITE_WIDTH, (int)PLAYER_SPRITE_WIDTH);

  gameObstacles = new ArrayList<>();
  activePowerUpsList = new ArrayList<>();

  float initialPlayerY = height - (rwgCurrentElevation * TILE_SIZE) - PLAYER_SPRITE_WIDTH / 2;
  player = new Player(width / 4, initialPlayerY, imgPlayer);

  gameState = STATE_GAME_RUN;
  println("Setup complete. Game running.");
}

// --- Main draw loop ---
void draw() {
  if (gameState == STATE_GAME_RUN) {
    background(152, 255, 250);

    updateCurrentGameSpeed();
    handleWorldScrollAndGeneration();

    player.update(worldTileData, TILE_SIZE, height, worldScrollPixelOffset);

    updateAndDrawObstacles();
    updateAndDrawPowerUps();

    drawWorldTiles(worldScrollPixelOffset);
    drawPlayerWithEffects();

    handleGameScore();
    drawGameHUD();
    checkActivePowerUpExpiration();

  } else if (gameState == STATE_GAME_OVER) {
    displayGameOverScreen();
  }
}

// --- Game logic helpers ---
void updateCurrentGameSpeed() {
  currentGameSpeed = baseGameSpeed;
  if (player.powerUpActivate && activePowerUpType == 2) { // Slow-mo
    currentGameSpeed = baseGameSpeed * 0.5f;
  }
}

void handleWorldScrollAndGeneration() {
  worldScrollPixelOffset += currentGameSpeed;
  if (worldScrollPixelOffset >= TILE_SIZE) {
    generateNextWorldColumnAndEntities();
    worldScrollPixelOffset -= TILE_SIZE;
  }
}

void updateAndDrawObstacles() {
  for (int i = gameObstacles.size() - 1; i >= 0; i--) {
    ObstacleBase o = gameObstacles.get(i);
    o.x -= currentGameSpeed;
    
    o.display();  // Draw spikes and Obstacle2 blocks
    
    if (o.checkCollision(player)) {
      if (player.powerUpActivate && activePowerUpType == 3) {
        // Invincible: no death
      } else {
        gameState = STATE_GAME_OVER;
        println("Game Over - Collision with: " + o.getClass().getSimpleName() + " at x=" + o.x + ", y=" + o.y);
        return;
      }
    }

    if (o.x + TILE_SIZE < 0) {  // Remove off-screen obstacles
      gameObstacles.remove(i);
    }
  }
}

void updateAndDrawPowerUps() {
  for (int i = activePowerUpsList.size() - 1; i >= 0; i--) {
    powerUpsBase pu = activePowerUpsList.get(i);
    pu.update(currentGameSpeed);
    pu.display();

    if (pu.checkCollected(player)) {
      pu.onCollect(player);
      activePowerUpsList.remove(i);
      println("Player collected power-up TYPE: " + player.powerUps);
    } else if (pu.x < -pu.size) {
      activePowerUpsList.remove(i);
    }
  }
}

void drawPlayerWithEffects() {
  if (player.powerUpActivate && activePowerUpType == 3) {
    pushStyle();
    tint(255, 223, 0, 200);
    player.display();
    popStyle();
  } else {
    player.display();
  }
}

void handleGameScore() {
  if (player.powerUpActivate && activePowerUpType == 1) scorePointValue = 2;
  else scorePointValue = 1;

  scoreFrameCounter++;
  if (scoreFrameCounter >= 10) {
    score += scorePointValue;
    scoreFrameCounter = 0;
  }
}

void drawGameHUD() {
  fill(0);
  textSize(32);
  textAlign(LEFT, TOP);
  text("Score: " + score, 20, 20);

  String pName = "";
  if (player.powerUpActivate) {
    pName = getPowerUpNameFromType(activePowerUpType);
    if (powerUpEffectTimer > 0) text("Active: " + pName + " (" + (powerUpEffectTimer / 60) + "s)", 20, 60);
  } else if (player.powerUps != 0) {
    pName = getPowerUpNameFromType(player.powerUps) + " (Press P)";
    text("Collected: " + pName, 20, 60);
  }
}

void checkActivePowerUpExpiration() {
  if (player.powerUpActivate) {
    powerUpEffectTimer--;
    if (powerUpEffectTimer <= 0) {
      println("Power-up expired: " + getPowerUpNameFromType(activePowerUpType));
      if (activePowerUpType == 2 && player != null) player.jumpStrength = player.originalJumpStrength;
      player.powerUpActivate = false;
      player.powerUps = 0;
      activePowerUpType = 0;
      scorePointValue = 1;
      powerUpEffectTimer = 0;
    }
  }
}

String getPowerUpNameFromType(int type) {
  switch (type) {
    case 1: return "Double Points";
    case 2: return "Slow Motion";
    case 3: return "Invincibility";
    default: return "";
  }
}

void displayGameOverScreen() {
  fill(255, 0, 0);
  textAlign(CENTER, CENTER);
  textSize(60);
  text("GAME OVER", width / 2, height / 2 - 40);
  textSize(40);
  text("Score: " + score, width / 2, height / 2 + 20);
  textSize(30);
  text("Press 'R' to Restart", width / 2, height / 2 + 70);
}

void keyPressed() {
  if (gameState == STATE_GAME_RUN) {
    if ((key == ' ' || key == CODED && keyCode == UP) && player != null && !player.isJumping) player.jump();
    if (key == 'p' || key == 'P') {
      if (player != null && player.powerUps != 0 && !player.powerUpActivate) {
        activePowerUpType = player.powerUps;
        powerUpEffectTimer = getDurationForPowerUpType(activePowerUpType);
        player.powerUpActivate = true;
        println("Activated power-up: " + getPowerUpNameFromType(activePowerUpType));
      } else if (player != null && player.powerUpActivate) {
        println("A power-up is already active!");
      } else {
        println("You don't have any power-ups to activate!");
      }
    }
  } else if (gameState == STATE_GAME_OVER) {
    if (key == 'r' || key == 'R') resetGame();
  }
}

int getDurationForPowerUpType(int type) {
  switch (type) {
    case 1: return 600;
    case 2: return 480;
    case 3: return 300;
    default: return 0;
  }
}

void resetGame() {
  println("Resetting game...");
  rwgCurrentElevation = 3;
  worldScrollPixelOffset = 0;
  rwgCanChangeElevation = true;
  rwgCanAddObstacle = true;
  rwgCurrentlyAddingFeature = false;
  rwgPostFeatureTimer = 0;
  rwgFeatureDurationCounter = 0;
  rwgRavineDepth = 0;
  rwgActiveFeatureTileType = TILE_AIR;

  initializeEmptyAirForRWG();

  gameObstacles.clear();
  activePowerUpsList.clear();

  if (player != null) {
    float initialPlayerY = height - (rwgCurrentElevation * TILE_SIZE) - PLAYER_SPRITE_WIDTH / 2;
    player.reset();
    player.y = initialPlayerY;
    player.x = width / 4;
  }

  score = 0;
  scoreFrameCounter = 0;
  scorePointValue = 1;
  activePowerUpType = 0;
  powerUpEffectTimer = 0;
  currentGameSpeed = baseGameSpeed;

  gameState = STATE_GAME_RUN;
  if (!looping) loop();
}

// --- RWG initialization function ---
void initializeEmptyAirForRWG() {
  worldTileData.clear();
  for (int i = 0; i < WORLD_VIEW_COLUMNS + 1; i++) {
    ArrayList<Integer> newColumn = new ArrayList<Integer>();
    for (int j = 0; j < WORLD_MAX_TILE_HEIGHT; j++) {
      if (j < rwgCurrentElevation) newColumn.add(TILE_GROUND);
      else newColumn.add(TILE_AIR);
    }
    worldTileData.add(newColumn);
  }
}

// --- RWG world generation ---
void generateNextWorldColumnAndEntities() {
  if (worldTileData.isEmpty()) {
    initializeEmptyAirForRWG();
    return;
  }

  worldTileData.remove(0);

  ArrayList<Integer> newTilesInColumn = new ArrayList<Integer>();
  for (int i = 0; i < WORLD_MAX_TILE_HEIGHT; i++) {
    newTilesInColumn.add(TILE_AIR);
  }

  if (rwgPostFeatureTimer <= 0) {
    rwgCanChangeElevation = true;
    rwgCanAddObstacle = true;
  }

  if (rwgCanChangeElevation && random(1) < 0.1) {
    int change = (random(1) < 0.5) ? -1 : 1;
    rwgCurrentElevation = constrain(rwgCurrentElevation + change, 2, WORLD_MAX_TILE_HEIGHT - 3);
  }

  if (rwgCanAddObstacle && !rwgCurrentlyAddingFeature && random(1) < 0.2) {
    rwgCurrentlyAddingFeature = true;
    rwgCanAddObstacle = false;
    rwgActiveFeatureTileType = TILE_AIR;

    int featureDecision = int(random(100));
    if (featureDecision < 10 && rwgCurrentElevation > 2) {
      rwgActiveFeatureTileType = 100; // gap code
      rwgFeatureDurationCounter = int(random(2, 5));
      rwgRavineDepth = int(random(1, rwgCurrentElevation - 1));
    } else if (featureDecision < 30) {
      rwgActiveFeatureTileType = TILE_SPIKE_PLACEHOLDER;
      rwgFeatureDurationCounter = int(random(1, 3));
      rwgRavineDepth = 0;
    } else if (featureDecision < 80) {  // Only Obstacle2 blocks now
      rwgActiveFeatureTileType = TILE_OBSTACLE2_PLACEHOLDER;
      rwgFeatureDurationCounter = int(random(1, 4));
      rwgRavineDepth = 0;
    } else if (featureDecision < 95) {
      rwgActiveFeatureTileType = TILE_POWERUP_DOUBLE_POINTS + int(random(3));
      rwgFeatureDurationCounter = 1;
      rwgRavineDepth = 0;
    } else {
      rwgCurrentlyAddingFeature = false;
      rwgCanAddObstacle = true;
    }

    if (rwgActiveFeatureTileType != TILE_AIR) {
      rwgPostFeatureTimer = rwgFeatureDurationCounter + int(random(2, 5));
    }
  }

  int effectiveGroundLevel = (rwgCurrentlyAddingFeature && rwgActiveFeatureTileType == 100)
                             ? max(0, rwgCurrentElevation - rwgRavineDepth)
                             : rwgCurrentElevation;

  for (int j = 0; j < WORLD_MAX_TILE_HEIGHT; j++) {
    newTilesInColumn.set(j, (j < effectiveGroundLevel) ? TILE_GROUND : TILE_AIR);
  }

  // Spawn spikes inside pits only if no Obstacle2 block in same tile
  if (rwgCurrentlyAddingFeature && rwgActiveFeatureTileType == 100) {
    if (rwgFeatureDurationCounter <= 2) { // Fill small pits only
      int pitFloorRow = rwgCurrentElevation - rwgRavineDepth;
      if (pitFloorRow >= 0 && pitFloorRow < WORLD_MAX_TILE_HEIGHT) {
        if (newTilesInColumn.get(pitFloorRow) != TILE_OBSTACLE2_PLACEHOLDER) {
          newTilesInColumn.set(pitFloorRow, TILE_SPIKE_PLACEHOLDER);
        }
      }
    }
  } else if (rwgCurrentlyAddingFeature && rwgFeatureDurationCounter > 0) {
    if (rwgActiveFeatureTileType == TILE_SPIKE_PLACEHOLDER || rwgActiveFeatureTileType == TILE_OBSTACLE2_PLACEHOLDER) {
      if (effectiveGroundLevel >= 0 && effectiveGroundLevel < WORLD_MAX_TILE_HEIGHT) {
        newTilesInColumn.set(effectiveGroundLevel, rwgActiveFeatureTileType);
      }
    } else if (rwgActiveFeatureTileType >= TILE_POWERUP_DOUBLE_POINTS) {
      int powerUpRow = min(WORLD_MAX_TILE_HEIGHT - 1, effectiveGroundLevel + 1);
      if (powerUpRow >= effectiveGroundLevel && newTilesInColumn.get(powerUpRow) == TILE_AIR) {
        newTilesInColumn.set(powerUpRow, rwgActiveFeatureTileType);
      }
    }
  }

  if (rwgCurrentlyAddingFeature) {
    rwgFeatureDurationCounter--;
    if (rwgFeatureDurationCounter <= 0) {
      rwgCurrentlyAddingFeature = false;
      rwgActiveFeatureTileType = TILE_AIR;
      rwgRavineDepth = 0;
    }
  }
  if (rwgPostFeatureTimer > 0) rwgPostFeatureTimer--;

  worldTileData.add(newTilesInColumn);

  int justAddedColIdx = worldTileData.size() - 1;
  float entitySpawnX = (justAddedColIdx * TILE_SIZE) + TILE_SIZE / 2.0f;

  // Spawn spikes first
  for (int j = 0; j < WORLD_MAX_TILE_HEIGHT; j++) {
    if (newTilesInColumn.get(j) == TILE_SPIKE_PLACEHOLDER) {
      float entityBaseY = height - (j * TILE_SIZE);
      gameObstacles.add(new Obstacle1(entitySpawnX, entityBaseY));
      newTilesInColumn.set(j, TILE_GROUND);
    }
  }
  // Spawn Obstacle2 blocks after spikes to draw on top
  for (int j = 0; j < WORLD_MAX_TILE_HEIGHT; j++) {
    if (newTilesInColumn.get(j) == TILE_OBSTACLE2_PLACEHOLDER) {
      float entityBaseY = height - (j * TILE_SIZE);
      gameObstacles.add(new Obstacle2(entitySpawnX, entityBaseY));
      newTilesInColumn.set(j, TILE_GROUND);
    }
  }

}

// --- Drawing ---
void drawWorldTiles(float scrollOffset) {
  for (int i = 0; i < worldTileData.size(); i++) {
    for (int j = 0; j < WORLD_MAX_TILE_HEIGHT; j++) {
      int tileType = worldTileData.get(i).get(j);
      float tileX = (i * TILE_SIZE) - scrollOffset;
      float tileY = height - ((j + 1) * TILE_SIZE);

      if (tileX < -TILE_SIZE || tileX > width + TILE_SIZE) continue;

      if (tileType == TILE_GROUND) {
        fill(0, 150, 0);
        noStroke();
        rect(tileX, tileY, TILE_SIZE, TILE_SIZE);
      }
    }
  }
}
