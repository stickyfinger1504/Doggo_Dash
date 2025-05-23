class Player {
  float x, y;               // Position of the player
  float velocityY = 0;      // Vertical velocity (affected by gravity)
  float gravity = 0.3;      // Gravity constant (affects fall speed)
  float jumpStrength = -10; // How strong the jump is
  boolean isJumping = false;// Check if the character is in the air
  float angle = 0;          // Rotation angle for the sprite
  float rotationSpeed = 90; // Degrees of rotation per jump
  boolean hasLanded = false;// Used to snap rotation once per landing

  float hw, hh;             // Half‐width & half‐height for collision

  PImage img;               // Image of the player

  Player(float startX, float startY, PImage playerImg) {
    x = startX;
    y = startY;
    img = playerImg;
    hw = squareWidth/2;
    hh = squareWidth/2;
  }

  // Reset to initial state
  void reset() {
    x = width/4;
    y = 0;
    velocityY = 0;
    isJumping = false;
    angle = 0;
    hasLanded = false;
  }

  // Land safely on a given y-coordinate
  void landOn(float groundY) {
    y = groundY - hh;
    velocityY = 0;
    isJumping = false;
    hasLanded = true;
    angle = snapAngle(angle);
  }

void update() {
  // 1) always apply gravity
  velocityY += gravity;
  y        += velocityY;
  
  float groundY = height * 0.75;  // your ground line
  
  // 2) ground collision
  if (y > groundY - hh) {
    landOn(groundY);
    return;
  }
  
  // 3) platform collision (both Obstacle2 & Obstacle3)
  //    land if falling through the top edge
  for (ObstacleBase ob : obstacles) {
    if (ob instanceof Obstacle2 || ob instanceof Obstacle3) {
      // cast so we can read w/h
      float px = x, py = y;
      float hw = this.hw, hh = this.hh;
      Obstacle2 b = (ob instanceof Obstacle2) 
                    ? (Obstacle2)ob 
                    : null;
      Obstacle3 p = (ob instanceof Obstacle3) 
                    ? (Obstacle3)ob 
                    : null;
      
      float topY, leftX, rightX;
      if (b != null) {
        topY   = b.y - b.h; 
        leftX  = b.x - b.w/2;
        rightX = b.x + b.w/2;
      } else {
        topY   = p.y - p.h;
        leftX  = p.x - p.w/2;
        rightX = p.x + p.w/2;
      }
      
      // only land if we're falling through that topY this frame
      boolean wasAbove = (y - velocityY) + hh <= topY;
      boolean nowHits   = y + hh >= topY;
      boolean withinX   = px + hw > leftX && px - hw < rightX;
      
      if (wasAbove && nowHits && withinX) {
        landOn(topY);
        return;
      }
    }
  }
  
  // 4) if we reach here, we didn’t land on anything: we stay in‐air
  isJumping = true;
}


  void display() {
    pushMatrix();
    translate(x, y);
    rotate(radians(angle));
    imageMode(CENTER);
    image(img, 0, 0);
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
