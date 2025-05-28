class powerUp1 extends powerUpsBase {
  powerUp1(float x, float y) {
    super(x, y);
  }

  void display() {
    fill(255, 255, 0);
    ellipse(x, y, size, size);
  }

  void onCollect(Player p) {
    p.powerUps = 1;
    println("Double points!");
  }
}
