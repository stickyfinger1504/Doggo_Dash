class Obstacle1 extends ObstacleBase {
  PImage blockImage;
  
  float angle = 0;
  
  Obstacle1(float x, float y, PImage image) {
    super(x, y, 80, 80);  // width=80, height=80
    
    blockImage = image;
  }

  void display() {
    //fill(0, 255, 0);
    //rectMode(CENTER);
    pushMatrix();
    translate(x, y);
    rotate(radians(angle));
    imageMode(CENTER);
    image(blockImage, 0, -40);
    popMatrix();
    //rect(x, y - h/2, w, h);  // Use base class fields
  }

  boolean checkCollision(Player p) {
    float left = x - w/2, right = x + w/2;
    boolean overlapX = p.x + p.hw > left && p.x - p.hw < right;
    if (!overlapX) return false;
  
    float top = y - h, bottom = y;
    float playerBottom = p.y + p.hh;
    float playerTop = p.y - p.hh;
  
    // Landing on top — no collision
    boolean landingFromAbove = playerBottom <= top + 1 && playerBottom + p.velocityY >= top;
    if (landingFromAbove) return false;
  
    boolean verticalOverlap = playerTop < bottom && playerBottom > top;
    boolean fromLeft = (p.x + p.hw > left) && (p.x < x);
  
    return verticalOverlap && fromLeft;  // true if collision from left
  }
}
