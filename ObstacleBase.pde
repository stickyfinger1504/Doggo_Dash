abstract class ObstacleBase {
  float x, y;
  float speed = 4;
  
  ObstacleBase(float startX, float startY) {
    x = startX;
    y = startY;
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
