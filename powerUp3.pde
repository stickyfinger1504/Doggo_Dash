// In powerUp3.java (or where powerUp3 class is defined)
class powerUp3 extends powerUpsBase {
  float duration = 300; // Duration in frames (e.g., 5 seconds at 60fps)

  powerUp3(float x, float y) {
    super(x, y);
  }

  @Override
  void display() {
    fill(255, 0, 255); // Magenta for Invincibility
    ellipse(x, y, size, size);
  }

  // @Override // Assuming onCollect is meant to be part of an interface or overridden
  void onCollect(Player p) {
    p.powerUps = 3; // Corrected: Set to type 3 for Invincibility
    println("Collected Invincibility!");
  }
}
