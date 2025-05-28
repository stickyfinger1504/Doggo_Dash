// In Player.java
class Player {
  float x, y;             // Player center position
  float velocityY = 0;
  float gravity = 0.35f;
  float originalJumpStrength = -11; 
  float jumpStrength = originalJumpStrength;
  boolean isJumping = true; // Assume airborne initially; landOn() will set to false.

  float hw, hh;             
  int powerUps = 0;         
  boolean powerUpActivate = false; 
  PImage img;

  Player(float startX, float startY, PImage playerImg) {
    x = startX;
    y = startY; 
    img = playerImg;
    // Use PLAYER_SPRITE_WIDTH from the main sketch (it's final, so effectively a constant)
    hw = PLAYER_SPRITE_WIDTH / 2; 
    hh = PLAYER_SPRITE_WIDTH / 2;
  }

  void reset() {
    velocityY = 0;
    isJumping = false; // Assume reset places player on initial ground
    jumpStrength = originalJumpStrength;
    powerUps = 0;
    powerUpActivate = false;
    // x and y are reset by the main sketch's resetGame() function based on RWG state
  }

  void landOn(float surfaceY) {
    y = surfaceY - hh; 
    velocityY = 0;
    isJumping = false; // Player is now landed
  }

  // Player's main update method
  void update(ArrayList<ArrayList<Integer>> worldTiles, int tileSize, int screenHeight, float worldScrollOffset) {
    // 1. ALWAYS apply gravity to current velocity
    velocityY += gravity;
    // 2. Update position based on new velocity
    y += velocityY;

    // Assume player is airborne for this frame's logic,
    // landing checks (here for tiles, or by objects via their checkCollision) will set isJumping = false.
    isJumping = true; 

    // 3. --- Collision with RWG Tile-Based Ground (basic TILE_GROUND) ---
    if (velocityY >= 0) { // Only attempt to land if moving downwards or was stationary
      float playerFeetY = y + hh;
      float playerPrevFeetY = (y - velocityY) + hh; 
      float playerLeftEdgeInWorld = (x - hw) + worldScrollOffset;
      float playerRightEdgeInWorld = (x + hw) + worldScrollOffset;
      int firstTileColToCheck = floor(playerLeftEdgeInWorld / tileSize);
      int lastTileColToCheck = floor(playerRightEdgeInWorld / tileSize);
      
      boolean landedOnTileThisUpdate = false;
      for (int currentCol = firstTileColToCheck; currentCol <= lastTileColToCheck; currentCol++) {
        if (currentCol >= 0 && currentCol < worldTiles.size()) { 
          int tileRowAtFeet = floor((screenHeight - playerFeetY) / tileSize);

          for (int rowOffset = 0; rowOffset <= 1; rowOffset++) { 
            int checkRow = tileRowAtFeet + rowOffset;
            if (checkRow >= 0 && checkRow < WORLD_MAX_TILE_HEIGHT) { // Use constant from main sketch
              if (worldTiles.get(currentCol).get(checkRow) == TILE_GROUND) { // Use constant from main
                float groundTileTopSurfaceY = screenHeight - ((checkRow + 1) * tileSize);
                float tileScreenLeftX = (currentCol * tileSize) - worldScrollOffset;
                float tileScreenRightX = tileScreenLeftX + tileSize;

                if ((x + hw > tileScreenLeftX && x - hw < tileScreenRightX) && 
                    playerFeetY >= groundTileTopSurfaceY && 
                    playerPrevFeetY <= groundTileTopSurfaceY + Math.max(1.0f, velocityY * 0.3f + 2.0f) ) { 
                  landOn(groundTileTopSurfaceY); 
                  landedOnTileThisUpdate = true; // isJumping is now false
                  break; 
                }
              }
            }
          }
        }
        if (landedOnTileThisUpdate) break; 
      }
      if (landedOnTileThisUpdate) {
          return; // Player landed on RWG tile ground, physics resolved for this frame by this method.
      }
    } 
    
    // If Player.update reaches here, it means:
    // - Player did NOT land on a basic RWG ground tile (TILE_GROUND) within this method.
    // - isJumping is still true (or was reset to true at start of this method).
    // - The player will continue their current trajectory (affected by gravity).
    // - Interactions with ObstacleBase objects (like your green Obstacle2 blocks)
    //   will be handled by their respective checkCollision() methods when called later
    //   in the main sketch's updateAndDrawObstacles() function. If an Obstacle2
    //   object calls player.landOn(), 'isJumping' will become false and velocityY will be 0
    //   for the *next* frame's Player.update().
  }

  void display() {
    pushMatrix();
    translate(x, y); 
    imageMode(CENTER);
    image(img, 0, 0);
    popMatrix();
  }

  void jump() {
    if (!isJumping) { 
      velocityY = jumpStrength;
      isJumping = true; 
    }
  }
}
