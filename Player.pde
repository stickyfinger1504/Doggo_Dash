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
  // 1) apply gravity & move unless you've already landed and haven't jumped again
  if (!(hasLanded && !isJumping)) {
    velocityY += gravity;
    y         += velocityY;
  }

  // 2) ground collision (same as before)
  float groundY = height * 0.75;
  if (y > groundY - hh) {
    landOn(groundY);
  }

  // 3) rotation while airborne
  if (isJumping) {
    angle += rotationSpeed * 0.1;
  }
  angle %= 360;
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
