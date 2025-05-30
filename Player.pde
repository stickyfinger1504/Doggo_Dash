class Player {
  float x, y;               // Position of the player
  float velocityY = 0;      // Vertical velocity (affected by gravity)
  float gravity = 0.3;      // Gravity constant (affects fall speed)
  float jumpStrength = -10; // How strong the jump is
  boolean isJumping = false;// Check if the character is in the air
  float angle = 0;          // Rotation angle for the sprite
  float rotationSpeed = 90; // Degrees of rotation per jump
  boolean hasLanded = false;// Used to snap rotation once per landing
  int powerUps=0;           // For the power up type it holds, null measn it doesnt have a power up
  boolean powerUpActivate=false;


  float hw, hh;             // Half‐width & half‐height for collision

  PImage[] img;               // Image of the player
  


  Player(float startX, float startY, PImage[] playerImg) {
    x = startX;
    y = startY;
    img = playerImg;
    hw = squareWidth / 2;
    hh = squareWidth / 2;
  }

  // Reset to initial state
  void reset() {
    x = width / 4;
    y = 0; // Or your player's initial Y
    velocityY = 0;
    isJumping = false;
    // angle = 0;
    // hasLanded = false;
  }

  // Land safely on a given y-coordinate
  void landOn(float groundY) {
    y = groundY - hh; // Adjust so player's feet are on groundY
    velocityY = 0;
    isJumping = false;
    // hasLanded = true;
    // angle = snapAngle(angle); // If using rotation
  }

  void update() {
    // 1) always apply gravity
    velocityY += gravity;
    y        += velocityY;

    float groundY = height * blockSize;  // your ground line

    // 2) ground collision
    if (y > groundY - hh) {
      landOn(groundY);
      return;
    }

    // 3) platform collision (both Obstacle1 & Obstacle3)
    //    land if falling through the top edge
    for (ObstacleBase ob : obstacles) {
      float topY, leftX, rightX;
      if (ob instanceof Obstacle1) {
        Obstacle1 b = (Obstacle1)ob;
        topY   = b.y - b.h;
        leftX  = b.x - b.w / 2;
        rightX = b.x + b.w / 2;
      } else if (ob instanceof Obstacle3) {
        Obstacle3 p = (Obstacle3)ob;
        topY   = p.y - p.h;
        leftX  = p.x - p.w / 2;
        rightX = p.x + p.w / 2;
      } else {
        continue; // skip other types
      }
      //if (ob instanceof Obstacle1 || ob instanceof Obstacle3) {
      //  // cast so we can read w/h
      //  float px = x, py = y;
      //  float hw = this.hw, hh = this.hh;
      //  Obstacle1 b = (ob instanceof Obstacle1)
      //    ? (Obstacle1)ob
      //    : null;
      //  Obstacle3 p = (ob instanceof Obstacle3)
      //    ? (Obstacle3)ob
      //    : null;

      //  float topY, leftX, rightX;
      //  if (b != null) {
      //    topY   = b.y - b.h;
      //    leftX  = b.x - b.w/2;
      //    rightX = b.x + b.w/2;
      //  } else {
      //    topY   = p.y - p.h;
      //    leftX  = p.x - p.w/2;
      //    rightX = p.x + p.w/2;
      //  }

      // only land if we're falling through that topY this frame
      boolean wasAbove = (y - velocityY) + hh <= topY;
      boolean nowHits  = y + hh >= topY;
      boolean withinX  = x + hw > leftX && x - hw < rightX;

      if (wasAbove && nowHits && withinX) {
        landOn(topY);
        return;
      }
    }
    isJumping = true;
  }



  void display(int frame) {
    pushMatrix();
    translate(x, y);
    rotate(radians(angle));
    imageMode(CENTER);
    image(img[(frame / 5) % 7], 0, 0);
    popMatrix();
  }

  void jump() {
    velocityY = jumpStrength;
    isJumping = true;
    hasLanded = false;
  }

  // Snap to nearest multiple of 90°
  float snapAngle(float a) {
    float deg = degrees(a);
    float snapped = round(deg/90)*90;
    if (snapped < 0)   snapped += 360;
    if (snapped >= 360) snapped -= 360;
    return snapped;
  }
}
