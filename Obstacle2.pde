class Obstacle2 extends ObstacleBase {
  float w = 80, h = 80;
  
  Obstacle2(float x, float y) {
    super(x,y);
  }
  
  void display() {
    fill(0,0,255);
    rectMode(CENTER);
    rect(x, y - h/2, w, h);
  }
  
  boolean checkCollision(Player p) {
    // first horizontal overlap
    float left = x - w/2, right = x + w/2;
    boolean overlapX = p.x+p.hw > left && p.x-p.hw < right;
    if(! overlapX) return false;
    
    float top = y - h, bottom = y;
    // landing on top?
    if(p.y + p.hh <= top+1 &&
       p.y + p.hh + p.velocityY >= top) {
      p.landOn(top);
      return false;
    }
    // otherwise side‐hit = death
    return (p.y - p.hh < bottom && p.y + p.hh > top);
  }
}
