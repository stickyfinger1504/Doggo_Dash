class Obstacle2 extends ObstacleBase {
  float w = 80, h = 80;

  Obstacle2(float x, float y_base) {
    super(x, y_base);
  }

  @Override
  void display() {
    fill(0, 150, 0);
    noStroke();
    rectMode(CORNER);
    rect(x - w / 2, y - h, w, h);
  }

  @Override
  boolean checkCollision(Player p) {
    float obsLeft = x - w / 2;
    float obsRight = x + w / 2;
    float obsTop = y - h;
    float obsBottom = y;

    float playerLeft = p.x - p.hw;
    float playerRight = p.x + p.hw;
    float playerTopEdge = p.y - p.hh;
    float playerFeet = p.y + p.hh;

    // Check horizontal overlap
    boolean horizontalOverlap = (playerRight > obsLeft && playerLeft < obsRight);
    if (!horizontalOverlap) {
      return false; 
    }

    // Check landing on top
    if (p.velocityY > 0.01f) { // falling down
      float playerPrevFeet = (p.y - p.velocityY) + p.hh;
      boolean wasAboveForLanding = playerPrevFeet < obsTop + (p.hh * 0.3f);
      if (wasAboveForLanding && playerFeet >= obsTop && playerFeet < obsBottom) {
        p.landOn(obsTop);
        return false; // landed safely, no death
      }
    }

    // If player collides otherwise (side or bottom), it's fatal
    boolean verticalOverlap = (playerTopEdge < obsBottom && playerFeet > obsTop);
    if (verticalOverlap) {
      return true;  // Fatal collision: player dies
    }

    return false;  // No collision otherwise
  }
}
