class Obstacle3 extends ObstacleBase {
  float w = 80, h = 40;
  
  Obstacle3(float x, float y) {
    super(x,y);
  }
  
  void display() {
    fill(0,0,255);
    rectMode(CENTER);
    rect(x, y - h/2, w, h);
  }
  
  boolean checkCollision(Player p) {
    // compute horizontal overlap
    float left  = x - w/2, right = x + w/2;
    boolean overlapX = p.x + p.hw > left && p.x - p.hw < right;
    if (!overlapX) return false;
    
    float top    = y - h,
          bottom = y;
    
    // if moving upward, always let through
    if (p.velocityY < 0) return false;
    
    // now only if you're falling and cross the top edge
    boolean wasAbove = p.y + p.hh <= top;
    boolean willCross = p.y + p.hh + p.velocityY >= top;
    if (wasAbove && willCross) {
      // land on top
      p.landOn(top);
    }
    
    // never kill on side hits, and no blocking from below
    return false;
  }
}
