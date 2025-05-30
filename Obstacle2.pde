class Obstacle2 extends ObstacleBase {
  float triW = 80, triH = 80;   // full size for drawing
  float hitW = 50, hitH = 20;   // smaller kill hitbox
  float angle = 0;
  PImage blockImage;

  Obstacle2(float x, float y, PImage image) {
    super(x, y, 80, 80);  // Using full 80x80 for position, w, h
    
    blockImage = image;
  }

  void display() {
    //fill(255, 0, 0);
    //noStroke();

    //// Draw the triangle inside the 80x80 box
    //beginShape();
    //vertex(x, y - triH);          // top tip
    //vertex(x + triW/2, y);        // bottom right
    //vertex(x - triW/2, y);        // bottom left
    //endShape(CLOSE);
    pushMatrix();
    translate(x, y);
    rotate(radians(angle));
    imageMode(CENTER);
    image(blockImage, 0, -40);
    popMatrix();
  }

  boolean checkCollision(Player p) {
    if (p.powerUpActivate && activePowerUp == 3) {
    float left  = x - w/2, right = x + w/2;
    boolean overlapX = p.x + p.hw > left && p.x - p.hw < right;
    if (!overlapX) return false;

    float top    = y - h;
      //bottom = y;

    // if moving upward, always let through
    if (p.velocityY < 0) return false;

    // now only if you're falling and cross the top edge
    boolean wasAbove = p.y + p.hh <= top;
    boolean willCross = p.y + p.hh + p.velocityY >= top;
    if (wasAbove && willCross) {
      // land on top
      p.landOn(top);
    }

    // never kill on side hits, and no blocking from below
    return false;
    } else {
      // Normal kill hitbox 50x20
      float halfW = hitW / 2;
      float halfH = hitH / 2;

      float left = x - halfW;
      float right = x + halfW;
      float top = y - halfH;
      float bottom = y + halfH;

      float pLeft = p.x - p.hw;
      float pRight = p.x + p.hw;
      float pTop = p.y - p.hh;
      float pBottom = p.y + p.hh;

      return (pRight > left && pLeft < right &&
        pBottom > top && pTop < bottom);
    }
  }
}
