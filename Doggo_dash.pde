// Main gameplay loop
final float squareWidth = 50;       // Player sprite size
PImage img;                         // Player image
ArrayList<ObstacleBase> obstacles;  // Holds all obstacle types
Player player;
float sprintGround;                 // 75% down the screen
float speed = 4;                    // Scroll speed
int GAME_STATE;
final int GAME_START = 1, GAME_RUN = 2, DIE = 3;
long score=0;
int scoreDistance;                  // adding up per interval
int activePowerUp = 0;              // 0 = none, 1 = double points, 2 = slow-mo, 3 = invincible
int POWERUP_DURATION=0;             // e.g. 10 seconds at 60fps
int incrementValue = 1;
int scoreCounter=0;
// <<< NEW VARIABLES START >>>
ArrayList<powerUpsBase> powerUpsList; // List to hold active power-ups on screen
PImage doublePointsImg;             // Image for double points power-up (optional)
PImage sloMoImg;                    // Image for slo-mo power-up (optional)

// Controls for spawning power-ups
int numDoublePointsToSpawn = 2;     // How many double points power-ups to create initially
int numSloMoToSpawn = 2;            // How many slo-mo power-ups to create initially
float powerUpInitialX = 800;        // Starting X position for the first power-up relative to width
float powerUpSpacingX = 600;        // Horizontal spacing between power-ups
// <<< NEW VARIABLES END >>>

// ... (previous new variables for powerUpsList etc.) ...

// <<< NEW VARIABLES FOR INVINCIBILITY START >>>
boolean gameMovementStoppedByInvincibility = false; // Flag to stop game scroll on spike hit
float baseScrollSpeed;                              // To store the original scroll speed
int numInvincibilityToSpawn = 1;                    // How many invincibility power-ups
int numObstacle1ToSpawnForTest = 5;                 // Number of spike obstacles for testing
// <<< NEW VARIABLES FOR INVINCIBILITY END >>>

void setup() {
  size(1600, 900);
  img = loadImage("sahur.jpg");
  img.resize((int)squareWidth, (int)squareWidth);

  baseScrollSpeed = speed; // Store the initial speed

  scoreDistance = 0;
  player = new Player(width / 4, 0, img);
  sprintGround = height * 0.75f;

  obstacles = new ArrayList<ObstacleBase>();
  powerUpsList = new ArrayList<powerUpsBase>();

  createObstacles(); // This function will now spawn power-ups and test obstacles
  GAME_STATE = GAME_RUN;
}

void draw() {
  switch (GAME_STATE) {
    case GAME_RUN:
      background(200);
      stroke(0);
      line(0, sprintGround, width, sprintGround);

      // --- Speed Management ---
      float actualSpeedThisFrame = baseScrollSpeed; // Start with the normal base speed

      if (gameMovementStoppedByInvincibility) {
        actualSpeedThisFrame = 0; // Game movement stops if invincible player hits a spike
      } else if (player.powerUpActivate && activePowerUp == 2) { // Slo-mo (and not stopped)
        actualSpeedThisFrame = baseScrollSpeed * 0.5f;
      }
      
      // Apply this frame's effective speed to the global 'speed' variable
      // that update() methods of entities might be using.
      float previousFrameGlobalSpeed = speed; // Store if needed, though likely overwritten each frame
      speed = actualSpeedThisFrame;
      // --- End Speed Management ---


      // Player update and display
      player.update(); // Player's update might use its own internal speed or rely on changes to 'y'

      // Visual cue for invincibility
      if (player.powerUpActivate && activePowerUp == 3) {
        pushStyle(); // Save current style
        tint(255, 223, 0, 200); // Golden semi-transparent tint for invincibility
        player.display();
        popStyle(); // Restore style (removes tint for other elements)
      } else {
        player.display();
      }

      // Update and display power-ups
      for (int i = powerUpsList.size() - 1; i >= 0; i--) {
        powerUpsBase pu = powerUpsList.get(i);
        pu.update(); // Uses the global 'speed' which is now actualSpeedThisFrame
        pu.display();

        if (pu.checkCollected(player)) {
          if (pu instanceof powerUp1) ((powerUp1)pu).onCollect(player);
          else if (pu instanceof powerUp2) ((powerUp2)pu).onCollect(player);
          else if (pu instanceof powerUp3) ((powerUp3)pu).onCollect(player); // Handle powerUp3
          powerUpsList.remove(i);
          println("Player collected power-up. Player has type: " + player.powerUps);
        } else if (pu.x < -pu.size) {
          powerUpsList.remove(i);
        }
      }

      // Score increment logic
      if (player.powerUpActivate && activePowerUp == 1) {
        incrementValue = 2;
      } else {
        incrementValue =1;
      }
      scoreCounter++;
      if(scoreCounter%10==0){
        score+=incrementValue;
        scoreCounter=0;
      }
      

      // Countdown power-up timer & expiration
      if (player.powerUpActivate) {
        POWERUP_DURATION--;
        if (POWERUP_DURATION <= 0) {
          println("Power up type " + activePowerUp + " expired");
          if (activePowerUp == 3) { // If invincibility expired
            gameMovementStoppedByInvincibility = false; // Allow game movement again
          }
          player.powerUpActivate = false;
          player.powerUps = 0;
          activePowerUp = 0;
          incrementValue = 1;
        }
      }

      // Display score and power-up status
      fill(0);
      textSize(32);
      textAlign(LEFT, TOP);
      text("Score: " + score, 20, 20);
      String pName = "";
      if (player.powerUpActivate) {
        switch(activePowerUp) {
          case 1: pName = "Double Points"; break;
          case 2: pName = "Slow Motion"; break;
          case 3: pName = "INVINCIBLE"; break; // Added Invincible
        }
        if (POWERUP_DURATION > 0) {
          text("Active: " + pName + " (" + (POWERUP_DURATION / 60) + "s)", 20, 60);
        }
      } else if (player.powerUps != 0) {
        switch(player.powerUps) {
          case 1: pName = "Double Points (Press P)"; break;
          case 2: pName = "Slow Motion (Press P)"; break;
          case 3: pName = "INVINCIBLE (Press P)"; break; // Added Invincible
        }
        text("Collected: " + pName, 20, 60);
      }

      // Obstacle loop: update, display, and collision
      for (int i = obstacles.size() - 1; i >= 0; i--) {
        ObstacleBase o = obstacles.get(i);
        o.update(); // Uses the global 'speed'
        o.display();

        if (o.checkCollision(player)) {
          if (player.powerUpActivate && activePowerUp == 3) { // INVINCIBILITY ACTIVE
            // Player does not die.
            if (o instanceof Obstacle1) {
              // "if the player collides from the front of the obstacle, the games simply just stop moving"
              println("Invincible player hit a spike! Game movement stopped.");
              gameMovementStoppedByInvincibility = true;
              // The "slide on top" behavior for Obstacle1 is tricky without changing Player class
              // or Obstacle1 fundamentally. With gameMovementStopped, Obstacle1 is stationary.
              // Player won't die and can attempt to jump on/over the static spike.
            }
            // For Obstacle2 and Obstacle3, invincibility means no death.
            // Their platform behavior is handled by Player.update()
          } else { // Not invincible
            GAME_STATE = DIE;
            noLoop(); // Stop draw loop
          }
        }

        if (o.x < -100 && obstacles.contains(o)) { // Check if obstacle still exists before trying to respawn
            // Respawn logic for obstacles (if any are to be respawned)
            // For this test, we are spawning a fixed set initially.
            // If you want continuous obstacles, you'd re-add them here.
            // Example: if (o instanceof Obstacle1) { obstacles.add(new Obstacle1(width, sprintGround)); }
            obstacles.remove(i);
        }
      }
      
      // Restore global speed if it was changed temporarily for updates AND if other parts of draw()
      // after this point expect the 'baseScrollSpeed' or its original value.
      // For now, 'speed' is recalculated at the start of each GAME_RUN frame.
      // speed = previousFrameGlobalSpeed; // Or speed = baseScrollSpeed;
      // This line is often not needed if 'speed' is treated as "current effective speed for updates".

      break;

    case DIE:
      // ... (DIE state remains the same) ...
      println("Game Over!");
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(50);
      text("Game Over! Score: " + score, width/2, height/2 - 30);
      text("Press 'R' to Restart", width/2, height/2 + 30);
      break;
  }
}

void keyPressed() {
  if (key == ' ' && !player.isJumping && GAME_STATE == GAME_RUN) {
    player.jump();
  }
  if (key == 'r' && GAME_STATE == DIE) {
    resetGame();
  }
  if (key == 'p' && GAME_STATE == GAME_RUN) {
    if (player.powerUps != 0 && !player.powerUpActivate) {
      activePowerUp = player.powerUps;

      switch (activePowerUp) {
        case 1: POWERUP_DURATION = 600; break; // Double Points
        case 2: POWERUP_DURATION = 480; break; // Slow-Mo
        case 3: POWERUP_DURATION = 300; break; // Invincibility (e.g., 5 seconds)
      }
      player.powerUpActivate = true;
      println("Activated power-up: " + activePowerUp + " for " + (POWERUP_DURATION / 60) + "s");
    } else if (player.powerUpActivate) {
      println("A power-up is already active!");
    } else {
      println("You don't have any power-ups to activate!");
    }
   }

  else{
    print("You don't have powerups!");
}
}
void resetGame() {
  player.reset();
  createObstacles(); // Spawns power-ups and test obstacles

  score = 0;
  scoreDistance = 0;

  POWERUP_DURATION = 0;
  activePowerUp = 0;
  player.powerUps = 0;
  player.powerUpActivate = false;
  incrementValue = 1;
  
  gameMovementStoppedByInvincibility = false; // Reset this flag
  speed = baseScrollSpeed; // Ensure speed is reset to base if it was changed

  GAME_STATE = GAME_RUN;
  loop();
}

//void createObstacles(){
//  // three spikes
//  for(int i=0; i<3; i++){
//    obstacles.add(new Obstacle1(width + i*800, sprintGround));
//  }
//  // three solid blocks
//  for(int i=0; i<3; i++){
//    obstacles.add(new Obstacle2(width + 400 + i*800, sprintGround));
//  }
//  // three one-way platforms
//  for(int i=0; i<3; i++){
//    obstacles.add(new Obstacle3(width + 200 + i*800, sprintGround));
//  }
//}

// Ensure these global variables are defined in your main sketch:
// int numInvincibilityToSpawn = 1; // (or more, one will be prioritized for early test)
// int numObstacle1ToSpawnForTest = 4; // Number of spikes in the test group
// int numDoublePointsToSpawn = 1;
// int numSloMoToSpawn = 1;
// float powerUpSpacingX = 600; // General spacing for subsequent power-ups

void createObstacles() {
  obstacles.clear();     // Clear any existing obstacles
  powerUpsList.clear();  // Clear any existing power-ups

  float currentX = width; // Starting reference for spawning off-screen to the right

  // --- Phase 1: Early Invincibility Power-up for Testing ---
  if (numInvincibilityToSpawn > 0) {
    // Spawn one invincibility power-up relatively close and easy to get
    // Adjust Y position as needed, sprintGround - 70 makes it float a bit
    powerUpsList.add(new powerUp3(currentX + 400, sprintGround - 70)); 
    println("Test: Spawned early Invincibility PowerUp at x=" + (currentX + 400));
  }

  // --- Phase 2: Spike Gauntlet for Testing Invincibility ---
  // This group of spikes should appear after the player has a chance to grab the first invincibility power-up.
  float spikeTestGroupStartX = currentX + 800; // Starts 400px after the early invincibility PU appears
  
  if (numObstacle1ToSpawnForTest > 0) {
    println("Test: Spawning " + numObstacle1ToSpawnForTest + " Obstacle1 (spikes) starting at x=" + spikeTestGroupStartX);
    for (int i = 0; i < numObstacle1ToSpawnForTest; i++) {
      // Spawn spikes close together to form a clear test hazard
      // Adjust spacing (e.g., 100, 120) based on your Obstacle1 sprite size
      float spikeX = spikeTestGroupStartX + (i * 120); 
      obstacles.add(new Obstacle1(spikeX, sprintGround)); 
    }
  }

  // --- Phase 3: Spawn Other Power-ups Further Down the Line ---
  // These will appear after the initial invincibility test setup.
  float furtherItemsX = spikeTestGroupStartX + (numObstacle1ToSpawnForTest * 120) + 400; // Start after the spike group

  // Spawn Double Points
  int doublePointsSpawned = 0;
  for (int i = 0; i < numDoublePointsToSpawn; i++) {
    powerUpsList.add(new powerUp1(furtherItemsX + (doublePointsSpawned * powerUpSpacingX), sprintGround - 60));
    doublePointsSpawned++;
  }
  if (doublePointsSpawned > 0) {
    furtherItemsX += doublePointsSpawned * powerUpSpacingX;
  }


  // Spawn Slo-Mo
  int sloMoSpawned = 0;
  for (int i = 0; i < numSloMoToSpawn; i++) {
    powerUpsList.add(new powerUp2(furtherItemsX + (sloMoSpawned * powerUpSpacingX), sprintGround - 80));
    sloMoSpawned++;
  }
   if (sloMoSpawned > 0) {
    furtherItemsX += sloMoSpawned * powerUpSpacingX;
  }

  // Spawn any additional Invincibility Power-ups if configured for more than one
  // (The first one was prioritized for the early test)
  int invincibilitySpawnedSoFar = (numInvincibilityToSpawn > 0) ? 1 : 0;
  for (int i = invincibilitySpawnedSoFar; i < numInvincibilityToSpawn; i++) {
     powerUpsList.add(new powerUp3(furtherItemsX + ((i - invincibilitySpawnedSoFar) * powerUpSpacingX), sprintGround - 70));
  }
}
