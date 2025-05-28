class Obstacle3 extends ObstacleBase {
  float w = 80, h = 40;
  
  Obstacle3(float x, float y) {
    super(x, y);
  }
  
  void display() {
    fill(0, 0, 255);
    rectMode(CENTER);
    rect(x, y - h / 2, w, h);
  }
  
  boolean checkCollision(Player p) {
    float left = x - w / 2, right = x + w / 2;
    boolean overlapX = p.x + p.hw > left && p.x - p.hw < right;
    if (!overlapX) return false;
    
    float top = y - h, bottom = y;
    
    if (p.velocityY < 0) return false; // moving upward, pass through
    
    boolean wasAbove = p.y + p.hh <= top;
    boolean willCross = p.y + p.hh + p.velocityY >= top;
    if (wasAbove && willCross) {
      p.landOn(top);
    }
    
    // no death on side hits
    return false;
  }
}
