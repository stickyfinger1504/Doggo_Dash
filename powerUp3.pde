class powerUp3 extends powerUpsBase {
  powerUp3(float x, float y) {
    super(x, y);
  }

  void display() {
    fill(255, 0, 255);
    ellipse(x, y, size, size);
  }

  void onCollect(Player p) {
    p.powerUps = 3;
    println("Invincibility!");
  }
}
