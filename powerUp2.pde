class powerUp2 extends powerUpsBase {
  float duration=240;
  PImage blockImage;
  powerUp2(float x, float y, PImage image) {
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
    p.powerUps=2;
    println("Slo-mo!");
  }
}
