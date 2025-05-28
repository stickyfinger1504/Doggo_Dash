// In ObstacleBase.java
abstract class ObstacleBase {
  float x, y; // For Obstacle objects, 'y' is typically their base coordinate.
  // NO local 'speed' variable here. Uses global 'currentGameSpeed'.

  ObstacleBase(float startX, float startY) {
    this.x = startX; // World X coordinate
    this.y = startY; // World Y coordinate (usually base of the object)
  }

  void update() {
    // Movement (x -= currentGameSpeed) is handled externally in the main sketch.
    // Subclasses can override for other animation/behavior.
  }

  abstract void display();
  abstract boolean checkCollision(Player p); // Returns true if FATAL, false if non-fatal (e.g. landing)
}
