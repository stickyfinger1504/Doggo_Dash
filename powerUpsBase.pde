abstract class powerUpsBase {
  float x, y;
  float baseY;        // Original y position to hover around
  float size = 30;
  boolean collected = false;

  // For hover effect
  float hoverAmplitude = 8;   // Pixels to move up/down
  float hoverFrequency = 0.05f; // Speed of hover oscillation
  float hoverAngle = 0;       // Angle to compute sine wave

  powerUpsBase(float x, float y) {
    this.x = x;
    this.y = y;
    this.baseY = y;
  }

  void update() {
    x -= speedTemp;  // move left with the world

    // Update hover offset using sine wave
    hoverAngle += hoverFrequency;
    if (hoverAngle > TWO_PI) hoverAngle -= TWO_PI;

    y = baseY + sin(hoverAngle) * hoverAmplitude;
  }

  abstract void display();

  boolean checkCollected(Player p) {
    float dist = dist(x, y, p.x, p.y);
    if (dist < size/2 + p.hw) {
      return true;
    }
    return false;
  }
}
