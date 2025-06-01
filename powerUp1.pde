class powerUp1 extends powerUpsBase {
  float duration=600;
  PImage blockImage;
  powerUp1(float x, float y, PImage image) {
    super(x, y);
    blockImage=image;
  }

  void display() {
    pushMatrix();
    translate(x, y);
    imageMode(CENTER);
    image(blockImage, 0, -40);
    popMatrix();
  }

  void onCollect(Player p) {
    // e.g., increase speed, duration etc.
    p.powerUps=1;
    println("Double points!");
  }
}
