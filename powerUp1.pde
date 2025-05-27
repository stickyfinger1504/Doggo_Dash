class powerUp1 extends powerUpsBase {
  float duration=600;
  powerUp1(float x, float y) {
    super(x, y);
  }

  void display() {
    fill(255, 255, 0);
    ellipse(x, y, size, size);
  }

  void onCollect(Player p) {
    // e.g., increase speed, duration etc.
    p.powerUps=1;
    println("Double points!");
  }
}
