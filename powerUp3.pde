class powerUp3 extends powerUpsBase {
  float duration = 300; // Duration in frames (e.g., 5 seconds at 60fps)

  PImage blockImage;
  powerUp3(float x, float y, PImage image) {
    super(x, y);
    blockImage=image;
  }

  @Override
    void display() {
    pushMatrix();
    translate(x, y);
    imageMode(CENTER);
    image(blockImage, 0, -40);
    popMatrix();
  }

  // @Override // Assuming onCollect is meant to be part of an interface or overridden
  void onCollect(Player p) {
    p.powerUps = 3; // Corrected: Set to type 3 for Invincibility
    println("Collected Invincibility!");
  }
}
