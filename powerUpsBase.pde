abstract class powerUpsBase {
  float x, y;
  float size = 30;
  
  powerUpsBase(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void update(float speed) {
    x -= speed; // move left at current speed
  }
  
  abstract void display();
  
  boolean checkCollected(Player p) {
    float d = dist(x, y, p.x, p.y);
    return d < (size / 2 + p.hw);
  }
  
  abstract void onCollect(Player p);
}
