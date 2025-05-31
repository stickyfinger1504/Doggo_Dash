class powerUp2 extends powerUpsBase {
  float duration=240;
  powerUp2(float x, float y) {
    super(x, y);
  }

  void display() {
    fill(0, 255, 255);
    ellipse(x, y, size, size);
  }

  void onCollect(Player p) {
    p.powerUps=2;
    println("Slo-mo!");
  }
}
