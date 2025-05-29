abstract class ObstacleBase {
  float x, y;
  float w, h;  // Add both width and height for generality

  ObstacleBase(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  // shared movement
  void update() {
    x -= speed;
  }

  // draw yourself
  abstract void display();

  // return true if this obstacle kills the player
  abstract boolean checkCollision(Player p);
}
