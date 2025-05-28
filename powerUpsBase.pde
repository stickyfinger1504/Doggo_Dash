abstract class powerUpsBase {
  float x, y;
  float size = 30;
  boolean collected = false;

  powerUpsBase(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    //x -= speed;  // move left with the world
  }

  abstract void display();

  // Check if player collected this powerup
  boolean checkCollected(Player p) {
    float dist = dist(x, y, p.x, p.y);
    if (dist < size/2 + p.hw) { // simple radius check
      //onCollect(p);
      return true;
    }
    return false;
  }
  // Effect when collected (override in subclasses)
  //abstract void onCollect(Player p);
}
